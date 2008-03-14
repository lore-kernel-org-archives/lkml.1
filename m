Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYCNRM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYCNRM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYCNRMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:12:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61719 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYCNRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:12:18 -0400
Message-ID: <47DAB1DD.8070009@oracle.com>
Date: Fri, 14 Mar 2008 10:11:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] Add macros similar to min/max/min_t/max_t.
References: <1205471926.19712.12.camel@brick>	 <20080314093451.cd3e644c.randy.dunlap@oracle.com>	 <1205513171.27712.1.camel@brick>  <47DAAC9E.1060001@oracle.com> <1205514408.27712.5.camel@brick>
In-Reply-To: <1205514408.27712.5.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Fri, 2008-03-14 at 09:49 -0700, Randy Dunlap wrote:
>> Harvey Harrison wrote:
>>> On Fri, 2008-03-14 at 09:34 -0700, Randy Dunlap wrote:
>>>> On Thu, 13 Mar 2008 22:18:45 -0700 Harvey Harrison wrote:
>>>> Where is some blurb/comment about what "clamp" means/does?
>>>> min/max are well understood, but clamp?  Is that a shop tool?
>>>> I think I have a few out in my garage.
>>> Sure, I'll do that..does kernel-doc actually work for macros?
>> Yes, it does.
>>
> 
> OK, here's what I've come up with:
> 
> /**
>  * clamp - return a value clamped to a given range with strict typechecking
>  * @val: current value
>  * @min: minimum allowable value
>  * @max: maximum allowable value
>  *
>  * This macro does strict typechecking of min/max to make sure they of the

                                                                 they are of

>  * same type as val.  See the unnecessary pointer comparisons.
>  */
> #define clamp(val, min, max) ({			\
> 	typeof(val) __val = (val);		\
> 	typeof(min) __min = (min);		\
> 	typeof(max) __max = (max);		\
> 	(void) (&__val == &__min);		\
> 	(void) (&__val == &__max);		\
> 	__val = __val < __min ? __min: __val;	\
> 	__val > __max ? __max: __val; })
> 
> /**
>  * clamp_t - return a value clamped to a given range using a given type
>  * @type: the type of variable to use
>  * @val: current value
>  * @min: minimum allowable value
>  * @max: maximum allowable value
>  *
>  * This macro does no typechecking and uses temporary variables of type
>  * 'type' to make all the comparisons.
>  */
> #define clamp_t(type, val, min, max) ({		\
> 	type __val = (val);			\
> 	type __min = (min);			\
> 	type __max = (max);			\
> 	__val = __val < __min ? __min: __val;	\
> 	__val > __max ? __max: __val; })
> 
> /**
>  * clamp_val - return a value clamped to a given range using val's type
>  * @val: current value
>  * @min: minimum allowable value
>  * @max: maximum allowable value
>  *
>  * This macro does no typechecking and uses temporary variables of whatever
>  * type the input argument 'val' is.  This is useful when val is an unisgned

                                                                      unsigned

>  * type and min and max are literals that will otherwise be assigned a signed
>  * integer type.
>  */
> #define clamp_val(val, min, max) ({		\
> 	typeof(val) __val = (val);		\
> 	typeof(val) __min = (min);		\
> 	typeof(val) __max = (max);		\
> 	__val = __val < __min ? __min: __val;	\
> 	__val > __max ? __max: __val; })
> 
> Comments?  Please let me know if I got the kerneldoc format right.

Yes, it looks fine.  Thanks.

-- 
~Randy
