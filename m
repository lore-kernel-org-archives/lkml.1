Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365Ab0ABNQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0ABNQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 08:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286Ab0ABNQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 08:16:44 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:12829 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0ABNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 08:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=FgOq8tS4PbbbyIhBcO+gQgfOaT+6Xt59cTXVf0qAJgQUj7Uxz1oYsrW0xGqZhG0e8k
         GwRmT21nWFVY7UXpbGKEBUwnbW1xy0VeJW19lNEz7MMDn3mXE5XIx9LcO3pyjSRG6hOc
         qIFXmC4s9enznaBKfcWVTbecZWJJ8wTU1wsCE=
MIME-Version: 1.0
Date: Sat, 2 Jan 2010 21:16:42 +0800
Message-ID: <78aa970c1001020516m3d2255fj38f02629e7d740c8@mail.gmail.com>
Subject: how to get right euid?
From: Kevin Qu <rofail@gmail.com>
To: dhowells@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote a kernel module and it create a "file" in /proc.
The "file" permission is set to 644.
When check access permission, I use :

if( op == 4 || (op ==2 && current->euid == 0) )
        return 0;

But it does not work on 2.6.29,
so I changed it like below:

if( op & 0x4 || (op & 0x2 && current_euid() == 0) )
        return 0;

It works when read from the "file" in /proc,
but when write to it with sudo, like:

sudo echo "some thing" > /proc/my_file

It denied. (But it works when I su to superuser and do so.)

So I checked the current_euid(),
but it returns 1000 (not 0),Why?

Thanks for help.

Rofail Qu
