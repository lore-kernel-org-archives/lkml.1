Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0BNJeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 04:34:13 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:36970 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab0BNJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 04:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vmt8nqHuOJ2KkfMwqc0v4eBdS35eM7i+TZB3OwminlYvIvNnq7/5EWchWa8e6gWYNY
         uybQ2WyneHlW2ZG+K1iAXY6lgnkt5o8H9PP2p1ugEXXGEHohCqLO8arnkTBvsex47uPI
         3uhnYzrbloz3O3ZuWeY87ssxkv5vXQjT23Kg0=
Message-ID: <4B77C362.7040909@gmail.com>
Date: Sun, 14 Feb 2010 01:33:22 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org>	<20100211205129.GA26105@elf.ucw.cz>	<20100213181008.479509f5@hyperion.delvare>	<4B773B31.1020802@lougher.demon.co.uk> <20100214102308.1d1d6fff@hyperion.delvare>
In-Reply-To: <20100214102308.1d1d6fff@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/10 01:23, Jean Delvare wrote:
> On Sat, 13 Feb 2010 23:52:17 +0000, Phillip Lougher wrote:
>> Jean Delvare wrote:
>>
>>>
>>> Compared to bz2, gz saves... 2% on the overall time. As a conclusion, I
>>> think we can plain discard the argument "I need .gz because my machine
>>> is slow" from now on. It simply doesn't hold.
>>>
>>
>> I agree, but, IMHO the main argument for keeping .gz is cross-platform
>> availability and wide language support, not hardware limitations.  Doing
>> a quick google brings up .gz interfaces for every language you can think
>> of (C, Java, Perl, Python, TCL etc.), not to mention complete separate
>> implementations in Java and Pascal (not just wrappers on top of the zlib
>> library), and probably more.
>>
>> With xz you have just one C/C++ implementation with a single library with
>> an undocumented API for C/C++ programmers.
>
> This can probably be easily explained. gz is very fast decompressing so
> it is a very good choice for transparent decompression of files which
> must be accessible fast but aren't used frequently. Manual pages or
> printer drivers come to mind. bz2 and lzma, OTOH, are meant for longer
> term archiving. Their compression ratio benefit is only worth it for
> larger files that you don't access that frequently.
>
> I am not claiming that gzip is dead. It is very useful and it is there
> to stay for the years to come, no doubt about that. What I'm saying is
> that it isn't the best choice for large files to be downloaded from a
> remote server.
>
>> It may be a slight stretch of the imagination, but with with .gz you can
>> conceive programmers writing programs to download a .gz from kernel.org and
>> decompressing/searching it, in almost any language of choice.  With the JAVA
>> implementation .gz is genuinely cross platform and you don't need glibc/
>> C++ compilers, just a Java VM.  Contrast with xz, where if the xz utility
>> isn't available, or doesn't do what you want, you're stuck with programming
>> in C/C++ with all the baggage that entails.
>
> Honestly, I don't think we care at all when it comes to the kernel.org
> files. Accessing individual files inside a compressed kernel tarball
> without first expanding it entirely would be horribly slow and
> unpractical, no matter which compression format was used. I can't think
> of any case where you won't unpack the tarball first, and for this task
> an external tool will do just fine.
>
> And, once again, there are several public instances of gitweb and LXR
> available if you only want to browse the code.
>

just out of curiosity what would happen if by say
I take a file and turn it into .gz then turn the .gz
into .xz or vice versa?

so at the end of the day you have a list of .gz's(or whatever),
then expending on the type(.gz,.bz2,etc..) unpackage and voila either a 
tree or some other compressed file(.bz2,xz, or .gz).

just thinking out loud(so don't shoot me please).

Justin P. Mattock
