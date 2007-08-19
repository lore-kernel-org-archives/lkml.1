Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbXHSQZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbXHSQZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 12:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXHSQZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 12:25:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:57984 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbXHSQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 12:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Mz5ggfx+JO2qTOv3PN3jHzlZFQwAWPblJL0o/YrSqHKo641Z+A/AHPdi8jBVjqr0rjd9yuE1dy2lrjgcQya9UcU7hLtofPLuyPCsmKWSuADq098jiTIzjK1L6D/GXvKb9mvGYzwXj+CBd2qE8IycNTdNcZZoMnd8Jqi4cYFANec=
Message-ID: <46C86EE8.1020803@gmail.com>
Date: Sun, 19 Aug 2007 18:25:12 +0200
From: Maciek Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <liml@rtr.ca>, Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: SATA error while resume
References: <46C80999.1060700@gmail.com> <46C852DE.8040701@rtr.ca> <46C85ED8.5080801@gmail.com> <46C8666F.4080603@gmail.com>
In-Reply-To: <46C8666F.4080603@gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo pisze:

> Hmmmm... Does Power-Off_Retract_Count increase after suspend/resume cycle?
>


No.

Before:

rutek:/home/maciek# smartctl -A -d ata /dev/sda  | grep
Power-Off_Retract_Count
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always
      -       66


Tested:

2.6.22.1 OK (double spin down of disk issue).

2.6.23-rc2 with patches [1] (prevent double spin down while suspend to
disk), also was tested ealier [2] OK

[1] http://www.ussg.iu.edu/hypermail/linux/kernel/0708.0/2655.html
[2] http://www.ussg.iu.edu/hypermail/linux/kernel/0708.0/2784.html


After:
rutek:/home/maciek# smartctl -A -d ata /dev/sda  | grep
Power-Off_Retract_Count
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always
      -       66


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
