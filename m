Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZBYNIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZBYNIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZBYNIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:08:14 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:65024 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbZBYNIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ix/pol/wvjoTk0IpoIb3e/3r6M1UU1QoZYJd9qLFhnqE2NX4vJVlMuibSxARoT4fGJ
         0nkM+AKC04DwX/C7aDKOEi6NWl+LxbBjX/Fz3vSEyFmWS4qzisT0hp8S6EUOrll2BP32
         +sOiHk+fRbFSC0y9j393a7dJQTgzv3ls9ljFE=
MIME-Version: 1.0
In-Reply-To: <87397bdf0902250503v2c9ac230od5c807f0b7d2e5f6@mail.gmail.com>
References: <87397bdf0902250503v2c9ac230od5c807f0b7d2e5f6@mail.gmail.com>
Date: Wed, 25 Feb 2009 21:08:11 +0800
Message-ID: <87397bdf0902250508u70fc4b55g323479840a0ea1bf@mail.gmail.com>
Subject: module buid issue with kbuild
From: des <desperatephilosopher@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have an issue building my kernel modules, generally the makefile
should look like:

obj-m = my_mod.o
my_mod-objs := $(the_obj_file_list)

if I list the obj files explicitly like
the_obj_file_list := a/obj1.o b/obj2.o c/obj3.o, it seems fine

Sometime there are too many obj files to add, so I want make to search
it automatically, so I use:
#find each of the .c files
mods := $(sort $(dir $(shell find . -name '*.c' -print)))
sources := $(wildcard $(addsuffix *.c,$(mods)))
#make the obj file list
objects := $(subst .c,.o,$(sources))
#remove the prefixing ./
myobjects := $(subst ./,,$(objects))

obj-m = my_mod.o
my_mod-objs := $(myobjects)
$(myobjects) should be exactly the same as $(the_obj_file_list) above,
I printed them in the makefile.

Unfortunately this does not work, it gives error messages below:
make[2]: *** No rule to make target
`/home/user/workingdir/scripts/bin2c.s', needed by
`/home/user/workingdir/scripts/bin2c.o'.  Stop.

Obviously bin2c is not in my working dir, it is in the kbuild directory.

I wonder if there is any way at all to avoid to write the full obj
list, it's really annoying.

Thanks a lot.
If you reply this post, please also CC to this address.
