Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZLIPIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZLIPIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 10:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZLIPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 10:08:23 -0500
Received: from mx.sz.bfs.de ([194.94.69.70]:43165 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZLIPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 10:08:22 -0500
Message-ID: <4B1FBD46.1050204@bfs.de>
Date: Wed, 09 Dec 2009 16:07:50 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Joe Perches <joe@perches.com>, Anton Altaparmakov <aia21@cam.ac.uk>,
       John Daiker <daikerjohn@gmail.com>, kernel-janitors@vger.kernel.org,
       aia21@cantab.net, linux-ntfs-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NTFS: Change string pointers to string constants.
References: <1259808806-27279-1-git-send-email-daikerjohn@gmail.com> <C1806924-DE57-4FBA-A67C-85C618FE6639@cam.ac.uk> <1260236833.3215.237.camel@Joe-Laptop.home> <20091209145846.GA3562@joi.lan>
In-Reply-To: <20091209145846.GA3562@joi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcin Slusarz schrieb:
> On Mon, Dec 07, 2009 at 05:47:13PM -0800, Joe Perches wrote:
>> On Tue, 2009-12-08 at 00:57 +0000, Anton Altaparmakov wrote:
>>> Can you please explain the rational for making this change?
>> Perhaps it's not worth much, but it saves a pointer reference.
>>
>> $ cat pointer.c
>> #include <string.h>
>> #include <stdio.h>
>>
>> int main (int argc, char** argv)
>> {
>> 	static const char *foo = "abcdefg";
>> 	printf("%s\n", foo);
>> 	return 0;
>> }
>>
>> $ gcc -c pointer.c
>> $ size pointer.o
>>    text	   data	    bss	    dec	    hex	filename
>>      37	      4	      0	     41	     29	pointer.o
>>
>> $ cat reference.c
>> #include <string.h>
>> #include <stdio.h>
>>
>> int main (int argc, char** argv)
>> {
>> static const char foo[] = "abcdefg";
>> printf("%s\n", foo);
>> return 0;
>> }
>>
>> $ gcc -c reference.c
>> $ size reference.o
>>    text    data     bss     dec     hex filename
>>      36       0       0      36      24 reference.o
> 
> Yeah, for static variables it's better. But for automatic variables
> it's worse, because it now has to do a copy at runtime.
> And the patch changes both types.
> 
> $ size pointer.o reference.o
>    text    data     bss     dec     hex filename
>     101       8       0     109      6d pointer.o
>      96       0       0      96      60 reference.o
> 
> $ size pointer-nonstatic.o reference-nonstatic.o
>    text    data     bss     dec     hex filename
>     106       0       0     106      6a pointer-nonstatic.o
>     109       0       0     109      6d reference-nonstatic.o
> --


nobody should spend to much time on this. gcc <what ever next version>
will have different results. It is better to spend time improving
the compiler and make it generate shorter/faster code.

just my 2 cents,
 wh
