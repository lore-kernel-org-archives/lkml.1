Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZJ0HYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZJ0HYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZJ0HYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:24:39 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64075 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZJ0HYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Q2OOaythIHVn3UlK0dCkq5gxqV70tICzgir0dGQCy5mHbDAKHhKfR+xbOOso3bKn/a
         PMe/Ygwo18gkd/8gIng21AJcIQFBkX8cv1YJUmOsoCCCoqr0JNYWbkzZWSpGLFMRCHYX
         E0911ITNo7wAEa3CwTZvOVJOKIoSwXcJBOXt0=
MIME-Version: 1.0
Date: Tue, 27 Oct 2009 00:24:43 -0700
Message-ID: <f22d86810910270024o4cd69265v61536afedc0e510b@mail.gmail.com>
Subject: Garbled printk output on 2.7.27 - No multi line printks
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying a simple char driver and for debug purposes I have added
lot of printks
in my module. The module is rather heavily being used by my test app which does
hundreds of open/read/write calls. The driver just copies and prints
incoming/outgoing
buffers.

I see a lot of garbled output in /var/log/messages

E.g.

Oct 27 00:18:47 ubuntu-vm kernel: [ 4903.382917] returned buf  "Hello"
Oct 27 00:18:47 ubuntu-vm kernel: [ 4903.382925] returned buf "Hello"
Oct 27 00:18:47 ubuntu-vm kernel: [ 4903.383033] returned buf "Hello"
reeeeeeeeeexeeeeeeexteeeexeeeeeeeeeeeeeeeeeeeeeeeeeeeeexeeeeeeeeeeeeeeeeeexeeeeeeeeeexteexeeeeeeeeexeeeeeeeeeeeeeeeeeeeeeeexeeeeeeeeeeeexeeeeeeeeeeeexeeeeeeeeeeeeeeeeeeeeexeeeeeeeeeeeeeeeeeeexeeeeeeeeeexteeeeeeeeeeeeeeexeeeext
for 8902 Hello
Oct 27 00:18:47 ubuntu-vm kernel: [ d
Oct 27 00:18:47 ubuntu-vm kernel: dddddddd
Oct 27 00:18:47 ubuntu-vm kernel:
ddddddddn3eexeeeeeeeeeeeeeeeexeeeeeeeeeeeeexeeeeexteeeeeeexeeeeeeeeeeeeeeeeeeeeeeeeeeexeeeeeeeeeexeeeeeeeeeeexeeeeeeeeeeeeexeeeeeeeeeeeeeexeeeeeeeeeexeeeeexeeeeeeeeeeeeeeeeeeeeeeexeeeeeeeeeeeeeeeeeeeeexeeeeeeeeeexeeeeeeeeeeeeeeeeexeeeeeeeext
for 8903 Hello


My loglevel is KERN_INFO, my understanding was a multiline printk
might cause garbled output
on SMPs but a single line printk is always protected using a semaphore.

-Leo.
