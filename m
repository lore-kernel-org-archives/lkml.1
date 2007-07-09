Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbXGICj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbXGICj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbXGICjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:39:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45856 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060AbXGICjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KhGj4bZPPaIC0RdsLMNbwPjpLlDVu+3ag94pVSSUbVEFwFtf3lIjwJ4MS7r/Di9Wmu9eKNHlZjlx41q3z4YC0Wl7vom8/AbFUR8IN/4DXPw9N5VwYy/MZrBsKDk1Kf5aRqPzhMF5B74yOZzoV90WG4E7wOJqxhRxLZcTcAFOyP8=
Message-ID: <46919FD1.2060203@googlemail.com>
Date: Mon, 09 Jul 2007 04:39:13 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravenborg.org
Subject: Re: [PATCH] fixup binutils printing from scripts/ver_linux
References: <200707090147.58611.jesper.juhl@gmail.com> <20070709020606.GA5761@martell.zuzino.mipt.ru>
In-Reply-To: <20070709020606.GA5761@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Jul 09, 2007 at 01:47:58AM +0200, Jesper Juhl wrote:
>   
>> I just found that scripts/ver_linux does not print the binutils version 
>> properly on my Slackware 12.0 system.
>>     
>
>   
>> --- a/scripts/ver_linux
>> +++ b/scripts/ver_linux
>> @@ -21,9 +21,8 @@ gcc --version 2>&1| grep gcc | awk \
>>  make --version 2>&1 | awk -F, '{print $1}' | awk \
>>        '/GNU Make/{print "Gnu make              ",$NF}'
>>  
>> -ld -v | awk -F\) '{print $1}' | awk \
>> -'/BFD/{print "binutils              ",$NF} \
>> -/^GNU/{print "binutils              ",$4}'
>> +echo "binutils               $(ld -v | awk -F \) \
>> +{'print $2'} | tr -d ' ')"
>>     
>
> NAK. It starts reporting here empty binutils field.
> FWIW,
>
> 	$ ld -v
> 	GNU ld version 2.16.1
>
>
>   

Well the format changed so now we have :

$ ld -v
GNU ld (Linux/GNU Binutils) 2.17.50.0.16.20070511

Maybe something like this may work :

echo "binutils $(ld -v | tr -d [:alpha:] | sed 's/.*)/\//;s/\///g' | tr 
-d ' ')"


Regards,

Gabriel C




