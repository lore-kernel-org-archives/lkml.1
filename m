Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYH0Mi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYH0Mi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYH0Mit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:38:49 -0400
Received: from web33207.mail.mud.yahoo.com ([209.191.69.155]:26522 "HELO
	web33207.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754513AbYH0Mis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:38:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=Vxym19qm9cqmflkhoJ0+TfjEFYds4dIZt2p2zdRNTPzI31ZCqWR3G5h6iGG6GC2FOOHdzk8U2BGmasEayCro+VOnAn7s94kK2ZG7bGCTzURavqItgrdheogbFNTXcvdptmHhX9Ml6KygFxf37JW/J23Jsj2NPaq+YeW++GxX1Ts=;
X-YMail-OSG: nJxxYvcVM1mxCa6V4noT70vfAylvwd_vd2EVbEdJkXC3ExxrmvnPUMnUl65yROtdk.KOfBooeULik5AJ.RUnMZfDCjHZaQEwrkK1X7juBGo.0DOpcw0MN2jLNZoTEfFAU826.qJfsprje5etOUTTcZGa
X-Mailer: YahooMailWebService/0.7.218.2
Date: Wed, 27 Aug 2008 05:38:48 -0700 (PDT)
From: jassi brar <jassi_singh_brar@yahoo.com>
Reply-To: jassi_singh_brar@yahoo.com
Subject: Re: An idea .... with code
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080827074751.GO26610@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <35042.98883.qm@web33207.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 8/27/08, Andi Kleen <andi@firstfloor.org> wrote:

> I fail to see what your patch generalizes? AFAIK it just
> adds a new
> more narrow (less features than the old one) interface to
> create loop devices.
 Btw, my code is not a patch to the loop driver, its an altogether new module. May i daresay, it aims squarely at drivers/block/loop.c and mean to replace it altogether.
 My module generalizes in the way that it doesn't add or make use of any ioctl. It doesn't even export a variable and makes uses only of what other subsystems provide for(block, sysfs, vfs).
 As far as features are concerned, please suggest me what could be done with /dev/loop0 and not for /dev/vblk?


> But you're adding more code which is more intrusive? 
 To be exact, i mean to _replace_ driver/block/loop.c, and hence _remove_ all the loop specific ioctls and max# limitations, with drivers/block/vblk.c :D



> Your goal is to replace all ioctls with sysfs files? 

  Please do have a look at the code.

 I add only one sysfs interface (manage), which when read returns the status of all the files being emulated and when written updates(add/remove) emulation of a file.
 The interface could be made more useful by echo'ing in other parameters along with filename for example:
echo +[r/w]+[sects]+[cyls]+[heads]+[filename] > /sys/devices/virblk/manage
 for specifyinf readonly, cylinders, heads, sectsize for the file to be emulated.


> If it's that then I'm going on the book as saying
> that's a bad idea, especially
> for this case. While ioctls have their problems they work
> quite well for many 
> things. I don't see any particular reason why ioctls
> should not be used
> to configure loop devices.
  I don't intend to revolt against the concept of ioctls. Being an embedded linux engineer I do understand the importance of ioctls: i declare one every other day for configuring custom h/w: Graphics and Multimedia esp so.
 As for loop devices, i think we can make do without'em.

Regards,
-Jassi


      
