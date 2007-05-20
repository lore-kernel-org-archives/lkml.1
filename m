Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXETUKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXETUKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXETUJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:09:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:16669 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbXETUJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LFwHy7ptAXZ8O+P2jk6xYsV+Osyo+RVRvYApeXB2ssZMBaFEvtEXfygpuPFAStWuBdJlyOVu99sDlwDAWUwDNzjk34hYTlnFxlBH0DxwN4xwIddhcQhZDv0OmNCzTA1F0otlksFZW0TpX7I4nZPgmzVagvXVAynq+W1JKlXI+g4=
Message-ID: <787b0d920705201309y16ba2778ob052fde375f0c58d@mail.gmail.com>
Date: Sun, 20 May 2007 16:09:56 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: setting all 3 file times
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why can we still not do this?

It's a stupid restriction. Security isn't a reason;
we have SE Linux policy and auditing to take
care of any issues. Heck, SE Linux policy could
even deny this feature for the truly paranoid.

Writing to /dev/* to update timestamps is surely
a worse security situation. (see "dump" program)

Ideally we'd have atomic update in some way.
That might mean feeding the old times into the
system call, so that the kernel can fail it if any
changes have happened meanwhile. Maybe the
syscall could take a pair of "struct stat" even,
making the operation really easy and powerful.
