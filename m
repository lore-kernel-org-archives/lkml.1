Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbXEKAxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbXEKAxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbXEKAxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:53:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:8204 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbXEKAxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type;
        b=LkUswL6hoXqFn0xFSSyNN8y2cKwR+nYtA2ltr2HMGPgNzfvQFBTEsdYXGYjGj5jj1prC8owgfBaSmxJsmb4M5keMe9oQF0/GW6qtoyHGfSFndqnaioRYGwDMsPq6Qm0JnGP0TyRyNJgBaGbeUsnbadO0ArEe/OtJ2M3414L3/Kc=
Message-ID: <4643BDF2.9030105@gmail.com>
Date: Fri, 11 May 2007 02:50:58 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: bunk@stusta.de, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       rpjday@mindspring.com, alan@lxorguk.ukuu.org.uk, marcel@holtmann.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] module_author: don't advice putting in an email address
Content-Type: multipart/mixed;
 boundary="------------090802000908010401040109"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090802000908010401040109
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Rusty.

Following up the recent MODULE_MAINTAINER discussion:

http://lkml.org/lkml/2007/4/4/170

that concluded with MODULE_MAINTAINER not being a good idea, here's a small 
patch that just deletes the advice of including an email address in the 
MODULE_AUTHOR tag as suggested (and not objected to) at the end of it.

The email address is the problem I was trying to fix; with multiple current 
and non-current authors and maintainers who might not even be authors the 
address(es) available from the tag confuse the issue of whom to contact. 
It's moreover also information that easily outdated.

A bit more than half of the tags in the tree don't include an email address 
already and I'll submit patches removing more...

Rene.


--------------090802000908010401040109
Content-Type: text/plain;
 name="module_author.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="module_author.diff"

commit 3b4fa382d5a6a3d9afdcb5a9232d63c47391fb30
Author: Rene Herman <rene.herman@gmail.com>
Date:   Fri May 11 02:24:35 2007 +0200

    module_author: don't advice putting in an email address
    
    It's information that's easily outdated and easily mistaken for
    a driver contact which is a problem especially for modules with
    multiple current and non-current authors as well as for modules
    with a maintainer who may not even be a module author.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/include/linux/module.h b/include/linux/module.h
index 792d483..e6e0f86 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -124,7 +124,7 @@ extern struct module __this_module;
  */
 #define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
 
-/* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
+/* Author, ideally of form NAME[, NAME]*[ and NAME] */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
   
 /* What your module does. */

--------------090802000908010401040109--
