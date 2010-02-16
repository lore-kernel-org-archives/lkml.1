Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0BPK7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:59:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43384 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0BPK7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Z1wR222pHIt5qTKaZxhn8HTEfZfk73tfSeW+i4fqePKQLuqlILhHlP44K6pcZIyfp3
         fjzKxqbUJq3YVQ2Dz3K3NOOoux0PKspsnaYFysjcX8v4xHkavBRSzFl+dFm/ZCA5PVqb
         99gaoWgzhmltHC3wF72OSY3n8+2lSVhLXZ5qM=
Message-ID: <4B7A7A7A.1000805@gmail.com>
Date: Tue, 16 Feb 2010 11:59:06 +0100
From: Troels Arvin <troels.arvin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: msgmnb limits?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On a server with lots of RAM (192GB), I ran into an application (DB2) 
which applies the following sysctl changes when it's started, if the 
values haven't already been set to - at least - the stated values:

  - kernel.msgmax = 65535
  - kernel.msgmnb = 65536

However, that doesn't work: Certain operations (LOAD and 
backups/restores) will fail with the following messages, unless 
kernel.msgmnb is increased:

DIA8557C No message was sent using the message queue.
CALLED  : OS, -, msgsnd                           OSERR: EAGAIN (11)
DATA #1 : system V message queue identifier., PD_TYPE_SYSV_QUEUE_ID


I tried setting kernel.msgmnb to 524288, and then things work. This 
value was chosen out of the blue, and I'd like to make a more informed 
choice:

  - Is there a limit to the size of msgmnb?
  - Can I expect the system to start thrashing if msgmnb is
    increased beyond a certain value?
  - Is my understanding correkt: msgmnb should always be at least
    as large as msgmax?

Thanks in advance.

-- 
Regards,
Troels Arvin
