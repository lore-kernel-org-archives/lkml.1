Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0BMTaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:30:10 -0500
Received: from xenotime.net ([72.52.64.118]:39289 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751228Ab0BMTaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:30:08 -0500
Message-ID: <4B76FDBF.8050902@xenotime.net>
Date: Sat, 13 Feb 2010 11:30:07 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jean Delvare <khali@linux-fr.org>, Pavel Machek <pavel@ucw.cz>,
       "J.H." <warthog9@kernel.org>,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>, users@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz>	 <20100213181008.479509f5@hyperion.delvare> <10f740e81002131049o196380a6tf863b7713e5aafc5@mail.gmail.com>
In-Reply-To: <10f740e81002131049o196380a6tf863b7713e5aafc5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/10 10:49, Geert Uytterhoeven wrote:
> On Sat, Feb 13, 2010 at 18:10, Jean Delvare <khali@linux-fr.org> wrote:
>> On Thu, 11 Feb 2010 21:51:29 +0100, Pavel Machek wrote:
>>> I believe this is cleanest. gzip has performance advantages, (...)
>>
>> I have been investigating this issue and would like to share my
>> findings as an additional data point for this discussion.
>>
>> For my testing, I have been using the slowest machine I still have
>> available here: a Pentium 166 MMX, with 64 MB of memory and a slow hard
>> disk drive. I've been writing down the duration of each task it took to
>> boot kernel 2.6.27.45 on this machine. I did this for both .gz and .bz2
>> formats.
>>
>> Raw results are as follow (format=min:s):
>>
>> downloading linux-2.6.27.tar.bz2          5:01
>> downloading patch-2.6.27.45.bz2           0:02
>> unpacking linux-2.6.27.tar.bz2            7:28
>> applying patch-2.6.27.45.bz2              1:21
>> ----------------------------------------------
>> total for bz2                            13:52
>>
>> downloading linux-2.6.27.tar.gz           6:23
>> downloading patch-2.6.27.45.gz            0:02
>> unpacking linux-2.6.27.tar.gz             3:20
>> applying patch-2.6.27.45.gz               1:10
>> ----------------------------------------------
>> total for gz                             10:55
>>
>> So the gz option is unsurprisingly faster, setting up the source tree
>> takes almost 3 minutes less (-21%).
>>
>> Then the (common) build and installation times:
>>
>> building                                117:26
>> installing modules                        0:12
>> ----------------------------------------------
>> total                                   117:38
>>
>> This is a customized kernel, as small as I could do, with almost no
>> features and the minimal set of drivers. As you can see, the build time
>> is one order of magnitude greater than the tree setup time. Comparing
>> the total times from download to install between bz2 and gz:
>>
>> bz2: 13:52 + 117:38 = 131:30
>> gz:  10:55 + 117:38 = 128:33
>>
>> Compared to bz2, gz saves... 2% on the overall time. As a conclusion, I
>> think we can plain discard the argument "I need .gz because my machine
>> is slow" from now on. It simply doesn't hold.
> 
> 166 MHz and 64 MB of RAM is still an order of magnitude more than some other
> machines Linux is capable of running on.
> 
> Of course we no longer build kernels on those machines natively, we
> cross-compile
> on much faster machines (and use git to fetch the kernel sources, FWIW ;-).
> 
> BTW, who still downloads full kernel tarballs? From my experience, that's mostly
> distro people who have scripts to build kernels from tarballs + a
> bunch of patches?

All of my daily build & boot testing downloads tarballs.
They use full linux-x.y.z for "releases" (like 2.6.32)
and they use patch-x.y.z.gz/bz2 for intermediate versions.

I don't mind updating the scripts to use .xz tarballs, but I would
really prefer to stick with tarballs instead of git trees.

> I guess actual developers use git nowadays, even if they're stuck on
> an old 2.6.x kernel?
> Backporting critical fixes is sooo much easier using git cherry-pick...
> 
> Do we have statistics about tarball downloads vs. git clone / git pull?

That would be good to see.

-- 
~Randy
