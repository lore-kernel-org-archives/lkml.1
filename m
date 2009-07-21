Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZGUCi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZGUCi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZGUCi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:38:59 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54833 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZGUCi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:38:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Message-id: <4A652A42.4040805@gmail.com>
Date: Mon, 20 Jul 2009 22:38:58 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre)
 Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl>
 <20090720151008.GC10015@suse.de>
 <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
 <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
 <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <4A650219.3060003@gmail.com>
 <alpine.LFD.2.01.0907201650570.19335@localhost.localdomain>
 <4A650DE1.20105@gmail.com>
 <alpine.LFD.2.01.0907201803170.19335@localhost.localdomain>
In-reply-to: <alpine.LFD.2.01.0907201803170.19335@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2009 09:05 PM, Linus Torvalds wrote:
>
> On Mon, 20 Jul 2009, Marc Dionne wrote:
>>> It could be ccache too, of course.
>> Actually in my case it turns out that it is ccache after all - if I remove it
>> from the picture everything is fine.  If I re-enable it, even with a clean
>> cache, I get the problem.
>>
>> It might just be a coincidence that it's triggered by the -fwrapv change.
>
> Btw, do you find any core-files lying around if you enable them before the
> build with
>
> 	ulimit -c unlimited
>
> or similar?
>
> And how did you clean ccache? There's "-c" and then there's "-C".
>
> 		Linus

Unfortunately I'm not able to reproduce anymore, after clearing 
/var/cache/ccache completely (rm -rf).  Earlier I had done ccache -C, 
which didn't help.  I didn't think to copy the contents for more analysis.

So perhaps a combination of some odd ccache state along with changing 
gcc, binutils (which I updated today) and the compile flag.  Revving 
binutils and gcc back and forth didn't reproduce it.

What is odd though is that when I straced a single gcc command line that 
produced an empty .o file, it looked normal - a series of successful 
writes with the correct amount of data to a temp file, close, unlink .o 
file, rename temp file -> .o file.  But the resulting file was empty. 
Make me wonder if there was something filesystem/caching related to it.

Marc
