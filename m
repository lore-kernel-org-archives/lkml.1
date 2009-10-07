Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbZJGTLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbZJGTLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZJGTLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:11:11 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:57538 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbZJGTLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aUHdLDmrrfYRg8HjYv0CVnMqKkwFIIaTJ82YKvrmXNnzp7lNY3ED7UVoRuQxbqxoE6
         0I43QBkVqziblSZvDoJIQcXgcDRUJ0W9pCAJkTRGLAc046lMP2rmtpMqtt9jmz0FTFcA
         tW5SvYkfuJzhVsqKew4Utbon4CTmS2TBGbwTY=
MIME-Version: 1.0
Date: Wed, 7 Oct 2009 15:10:33 -0400
Message-ID: <68f1f87c0910071210l7d13ae3cueed7a7f24c669e35@mail.gmail.com>
Subject: Query about process address space
From: Hayawardh V <hayawardh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ashwin Chaugule <ashwin.chaugule@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

generally the text segment of the program gets mapped into the virtual
address starting at
0x8048000 ....

but in the case of certain programs like sshd, apache, postgres, when
I examine the proc/pid/maps, I get that the program is mapped higher
in memory (ie) in the mmap space.
eg: cat /proc/sshd/maps

...
b7fd2000-b7fd3000 r--p 0001a000 08:01 5144607    /lib/ld-2.8.90.so
b7fd3000-b7fd4000 rw-p 0001b000 08:01 5144607    /lib/ld-2.8.90.so
b7fd4000-b8038000 r-xp 00000000 08:01 656219     /usr/sbin/sshd
b8039000-b803a000 r--p 00064000 08:01 656219     /usr/sbin/sshd
b803a000-b803b000 rw-p 00065000 08:01 656219     /usr/sbin/sshd
b803b000-b8040000 rw-p 00000000 00:00 0
b8779000-b87be000 rw-p 00000000 00:00 0          [heap]
bfeed000-bff02000 rw-p 00000000 00:00 0          [stack]

(on linux-2.6.30)

This seems to be the mmap space. Why do programs mmap themselves in
higher memory? Or is there some other reason and is this not the mmap space?

Thanks,
Hayawardh
