Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXHCE5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXHCE5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 00:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXHCE5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 00:57:14 -0400
Received: from [202.78.101.198] ([202.78.101.198]:38524 "EHLO mx1.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752055AbXHCE5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 00:57:13 -0400
Message-ID: <46B2B5B3.5050303@gmail.com>
Date: Fri, 03 Aug 2007 12:57:23 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B2578A.805@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Thu, 2 Aug 2007, Robert Hancock wrote:
> 
>> Because 5 characters will not fit in a 4 character array, even without the
>> null terminator.
> 
> On Fri, 3 Aug 2007, Stefan Richter wrote:
> 
>> How should gcc know whether you actually wanted that char foo[len] to
>> contain a \0 as last element?
> 
> Robert, Stefan, I am sorry, I think, you are VERY wrong here. There is no 
> "even" and no guessing. The "string" DOES include a terminating '\0'. It 
> is EQUIVALENT to {'s', 't', 'r', 'i', 'n', 'g', '\0'}. And it contains 
> SEVEN characters. Please, re-read your K&R. Specifically, the Section 
> "Initialization" in the "Function and Program Structure" chapter (section 
> 4.9 in my copy), the paragraph about initialization with a string, which I 
> quoted in an earlier email.

Guennadi,

The declaration

char c[4] = "abcd";

is perfectly valid.

If other versions of gcc give warnings with that declaration, then those 
warnings may be useful but it does not mean to say that other versions of 
gcc follow the standards or not.

K&R is good as a reference but not as an authority.  They drafted the book 
as an informal specification of C.  C has evolved throughout the decades.

The current standard is C99. And as quoted earlier in this thread, 
character array initializations are described as:

6.7.8.14 of C99:
An array of character type may be initialized by a character string 
literal, optionally enclosed in braces. Successive characters of the 
character string literal (including the terminating null character if there 
is room or if the array is of unknown size) initialize the elements of the 
array.

The gcc warning you see on other versions is a warning that does not have 
anything to do with the current C standard. The other versions of gcc that 
do not emit such character initialization warnings do not mean that they 
are buggy in that respect.

IOW, the fact that you did not see the warning  in a certain gcc version 
does not mean that it is buggy in that respect.

Thank you very much.

Best Regards,

Carlo

-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, UP Campus Diliman
1101 Quezon City, Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
