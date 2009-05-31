Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZEaLP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZEaLP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 07:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbZEaLPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 07:15:21 -0400
Received: from mxout2.netvision.net.il ([194.90.9.21]:19135 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525AbZEaLPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 07:15:21 -0400
Date: Sun, 31 May 2009 14:15:41 +0300
From: Alon Ziv <alon@nolaviz.org>
Subject: Preferred kernel API/ABI for accelerator hardware device driver
To: linux-kernel@vger.kernel.org
Message-id: <001401c9e1e1$2a68eb20$7f3ac160$@org>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=windows-1255
Content-language: en-us
Content-transfer-encoding: 8BIT
Thread-index: Acnhr06pv/c+8oyJTL2niI2m63ogAw==
x-cr-puzzleid: {228064AE-8263-4858-8AB2-03FB1D4F7585}
x-cr-hashedpuzzle: WBg= AvrB CjZt DBH7 DEtb DGBM DRh8 EEIL El7i EoVw E31O FHzp
 Izt8 I+Ew JC5d
 JX6H;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{228064AE-8263-4858-8AB2-03FB1D4F7585};YQBsAG8AbgBAAG4AbwBsAGEAdgBpAHoALgBvAHIAZwA=;Sun,
 31 May 2009 11:15:39
 GMT;UAByAGUAZgBlAHIAcgBlAGQAIABrAGUAcgBuAGUAbAAgAEEAUABJAC8AQQBCAEkAIABmAG8AcgAgAGEAYwBjAGUAbABlAHIAYQB0AG8AcgAgAGgAYQByAGQAdwBhAHIAZQAgAGQAZQB2AGkAYwBlACAAZAByAGkAdgBlAHIA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am looking for advice on the proper design of an API for a device driver
for hardware acceleration (e.g. a JPEG decoder or a cryptographic function
accelerator).  These hardware modules don’t appear to map properly to the
standard device-driver paradigm (i.e., a “device file” that communicates
with userspace using read()/write() system calls), as we need to pass input
data into the kernel and receive transformed output directly. The only way I
see to use standard IO operations on such drivers is by copying the data
into temporary kernel buffers, which is (a) a pain and (b) horribly
inefficient.

Currently the only way I see around this limitation is to implement all
communications with such a driver using ioctl() operations, but this isn’t a
very satisfactory solution—for example, it does not provide a way to do
something similar to “writev()” (gathering several buffers for a single
processing operation).

Should I just take the plunge and implement a new “iov(fd, iov_in,
iovcnt_in, iov_out, iovcnt_out)” system call?
Does anyone have a better idea for an interface that will allow zero-copy
interfacing to a transformation driver from userspace?

                -az



