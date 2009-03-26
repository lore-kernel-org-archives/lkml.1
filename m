Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZCZWeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZCZWeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZCZWeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:34:01 -0400
Received: from col0-omc2-s17.col0.hotmail.com ([65.55.34.91]:29200 "EHLO
	col0-omc2-s17.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbZCZWeA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:34:00 -0400
Message-ID: <COL112-W70B31F9B113D4E450DAD09C8910@phx.gbl>
X-Originating-IP: [76.197.186.32]
From: Adam Turk <bofh1234@hotmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: recommended programming practices for writing (was Linux	2.6.29)
Date: Thu, 26 Mar 2009 18:33:58 -0400
Importance: Normal
In-Reply-To: <1238096043.13457.4.camel@spike.firmix.at>
References: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
 <1238096043.13457.4.camel@spike.firmix.at>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Mar 2009 22:33:59.0037 (UTC) FILETIME=[F4978AD0:01C9AE62]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On Thu, 2009-03-26 at 15:03 -0400, Adam Turk wrote:
>> I have been reading the Linux 2.6.29 thread with interest. I have
>> written several (10 or so) C programs that write large amounts of data
>> (between 1 and 2 GB file sizes are common). A snippet of code looks
>> like this:
>>
>> if((fptr = fopen(outfilename,"w")) == NULL) {
>> printf("File %s could not be created\n", outfilename);
>> }
>> else {
>> fprintf(fptr,"%s\n",datablock);
>> while(!writeouput(datablock,amount,tax)) {
>> getnext(dtablock)
>> fprintf(fptr,"%s\n",datablock);
>> }
>> fclose(fptr);
>> }
>>
>> I learned C about 15 years ago and there was no mention of a fsync.
>> My C book doesn't mention fsync either. Granted I have written only
>
> Probably because fsync() is a system call (and not a standard C lib
> function).
>
> [...]
>> From what Linus posted about git and checking the return from fclose I
>> think I going to start doing that. I also think I am going to start
>> checking the return from fprintf and maybe write to a /tmp/file and
>> then rename it.
>
> For a really robust app it's probably not wrong. At least one gets an
> error (e.g. "disk full") immediately and not only at fclose() time after
> (trying to) write 2GB data.
>
>> So is there a C fsync that I should add before my fclose?
>
> "fflush(fptr);" flushes all of the buffers (managed by the C-lib) of
> fptr and also delivers an error.
> fsync() is to flush the in-kernel cached pages of that file.
>
>> What is the proper way to write to files?
>
> Basically just as you do above.
>
> Bernd
 
Thank you for the tips. 
 
Thanks,
Adam
_________________________________________________________________
Quick access to Windows Live and your favorite MSN content with Internet Explorer 8.
http://ie8.msn.com/microsoft/internet-explorer-8/en-us/ie8.aspx?ocid=B037MSN55C0701A