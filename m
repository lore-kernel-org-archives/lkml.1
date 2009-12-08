Return-Path: <linux-kernel-owner+w=401wt.eu-S965839AbZLHTWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839AbZLHTWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 14:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965825AbZLHTWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 14:22:05 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:44303 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965822AbZLHTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 14:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rrqYLTy5mfX1TKWEInkiZGRUG6JWf6lQiO+5aiRonqNrdkkuM4mXBl0NyFNq6xr4z5
         TrkmejX2es13sgcCiCkAzIEFfJngzo5mqoDN5XaI52b0sUJUnIDKDqW2rg5ZCv/2e9BX
         lB3Hx+31D0JFlaeMerhK623tj9APFpBkWrN84=
Message-ID: <4B1EA61A.2000804@gmail.com>
Date: Tue, 08 Dec 2009 11:16:42 -0800
From: John Daiker <daikerjohn@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.5) Gecko/20091204 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: Anton Altaparmakov <aia21@cam.ac.uk>
CC: Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
       aia21@cantab.net, linux-ntfs-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NTFS: Change string pointers to string constants.
References: <1259808806-27279-1-git-send-email-daikerjohn@gmail.com>	 <C1806924-DE57-4FBA-A67C-85C618FE6639@cam.ac.uk> <1260236833.3215.237.camel@Joe-Laptop.home>
In-Reply-To: <1260236833.3215.237.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2009 05:47 PM, Joe Perches wrote:
> On Tue, 2009-12-08 at 00:57 +0000, Anton Altaparmakov wrote:
>> Can you please explain the rational for making this change?
>
> Perhaps it's not worth much, but it saves a pointer reference.
>
> $ cat pointer.c
> #include<string.h>
> #include<stdio.h>
>
> int main (int argc, char** argv)
> {
> 	static const char *foo = "abcdefg";
> 	printf("%s\n", foo);
> 	return 0;
> }
>
> $ gcc -c pointer.c
> $ size pointer.o
>     text	   data	    bss	    dec	    hex	filename
>       37	      4	      0	     41	     29	pointer.o
>
> $ cat reference.c
> #include<string.h>
> #include<stdio.h>
>
> int main (int argc, char** argv)
> {
> static const char foo[] = "abcdefg";
> printf("%s\n", foo);
> return 0;
> }
>
> $ gcc -c reference.c
> $ size reference.o
>     text    data     bss     dec     hex filename
>       36       0       0      36      24 reference.o
>
>
>

As Joe mentioned above (thanks Joe!) it saves a pointer reference.

It is also listed as a KernelJanitors ToDo item (about 2/3 of the way 
down the page).  Searching for 'From: Jeff Garzik' should find it.

John

[1] http://kernelnewbies.org/KernelJanitors/Todo
