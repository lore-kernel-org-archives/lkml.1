Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbXBFScB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbXBFScB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbXBFScA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:32:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:51543 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbXBFScA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gLwWZ1vgEnXHcUw54ByZh5W/vOm34Ei8H+e3h6hFkKd1UehRtOhYpqA7/g5uGGoMN7VNrjbo9XToLtspa59c50bLjVA83ziXyC8dNM4Sk3YButySimaqfW6bn1Mhf3uQwnYaGZALFubgw0KCndudoxxHtRbge0PcyLLlSXp8IEw=
Message-ID: <c70ff3ad0702061031i6face64ai946d6893b960645b@mail.gmail.com>
Date: Tue, 6 Feb 2007 20:31:58 +0200
From: "saeed bishara" <saeed.bishara@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: cache coherecy when working with cpu dcache write allocate
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I came across data corruption problem when using xfs, my system is
arm 926, the data cache is virtually tagged and virtually indexed and
with no hw cache coherency. my CPU features the data cache write
allocate-> when doing store, the cache line of the destination address
is loaded to data cache.
  when enabling the write allocate, I got data corruption with the
xfs. the scenario is that the xfs allocates large buffer (for reading
the log records) using vmalloc, and the low level driver (raid) copies
the data to the bio vectors using the linear address, since the write
allocate is enabled,  the correct data remains on the data cache with
the linear address tag, when the IO completes, the xfs access the data
with using the vmalloc virtual address, which is different than the
kernel linear address, thus it will get a stale data!.

how should I fix this problem? I thought that only the
copy/clean_user_pages() functions should be aware to the write
allocate.

saeed
