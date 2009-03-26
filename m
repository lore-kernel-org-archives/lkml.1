Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbZCZTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbZCZTen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbZCZTee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:34:34 -0400
Received: from ns.firmix.at ([62.141.48.66]:4519 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbZCZTed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:34:33 -0400
Subject: Re: recommended programming practices for writing (was Linux
	2.6.29)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Adam Turk <bofh1234@hotmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
References: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 26 Mar 2009 20:34:03 +0100
Message-Id: <1238096043.13457.4.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.048 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.048 required=5
X-Spam-Score: -1.048 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 15:03 -0400, Adam Turk wrote:
> I have been reading the Linux 2.6.29 thread with interest.  I have
> written several (10 or so) C programs that write large amounts of data
> (between 1 and 2 GB file sizes are common).  A snippet of code looks
> like this:
> 
> if((fptr = fopen(outfilename,"w")) == NULL) {
>   printf("File %s could not be created\n", outfilename);
> }
> else {
>   fprintf(fptr,"%s\n",datablock);
>   while(!writeouput(datablock,amount,tax)) {
>     getnext(dtablock)
>     fprintf(fptr,"%s\n",datablock);
>   }
>   fclose(fptr);
> }
> 
> I learned C about 15 years ago and there was no mention of a fsync.
> My C book doesn't mention fsync either.  Granted I have written only

Probably because fsync() is a system call (and not a standard C lib
function).

[...]
> From what Linus posted about git and checking the return from fclose I
> think I going to start doing that.  I also think I am going to start
> checking the return from fprintf and maybe write to a /tmp/file and
> then rename it.

For a really robust app it's probably not wrong. At least one gets an
error (e.g. "disk full") immediately and not only at fclose() time after
(trying to) write 2GB data.

> So is there a C fsync that I should add before my fclose?

"fflush(fptr);" flushes all of the buffers (managed by the C-lib) of
fptr and also delivers an error.
fsync() is to flush the in-kernel cached pages of that file.

> What is the proper way to write to files?

Basically just as you do above.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


