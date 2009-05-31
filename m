Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbZEaOxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbZEaOxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbZEaOxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:53:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:31131 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbZEaOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=t0mHAWACtGw+9PUOyBkgspvz7Mh0fYu7xOqYZpWtOtcezGsrxAEAWP1AKP9VjkgSzT
         U5MP9mh6cOeuFOpZdFMfHwZzmNIVL7IUtGWlIe6DPjTGoYB68vxXwAdQjZ6+m9k+FP7p
         zANa9lznSXEsuG3tvfjlfCkPxNyEqb9ohWIw8=
Message-ID: <4A229998.6070808@gmail.com>
Date: Sun, 31 May 2009 16:52:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@gmail.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: broken ide-tape
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ide-tape is broken since commit 346331f82823682fb5c2df6e827db25d95cc2e92
(ide-tape: remove atomic test/set macros for packet commands)
from Apr 18 2008.

The commit introduced flags which are defined as (1 << nr) and uses them
in {clear,set,test}_bit. And hence it must oops on each do_request.

Is it worth fixing (something like ilog2 added to each bit operation) or
is a complete removal of the driver better "fix"?
