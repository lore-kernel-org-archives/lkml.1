Return-Path: <linux-kernel-owner+w=401wt.eu-S1761101AbZFSWh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101AbZFSWh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759528AbZFSWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:32:40 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:36030 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbZFSWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:31:25 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 18:31:25 EDT
Message-ID: <4A3C0FF6.3080300@cmu.edu>
Date: Fri, 19 Jun 2009 18:23:50 -0400
From: "Jonathan M. McCune" <jonmccune@cmu.edu>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       tpmdd-devel@lists.sourceforge.net, seiji.munetoh@gmail.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module
 for 2.6.30
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>	<1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>	<4A3474BD.4000804@linux.vnet.ibm.com>	<b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>	<1245007238.10712.5.camel@blackbox>	<1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com>	<4A367093.6010206@linux.vnet.ibm.com>	<4A36C04B.6070204@linux.vnet.ibm.com>	<1245185391.2848.30.camel@localhost.localdomain> <23397_1245442186_n5JK9jDX021038_1245442176.31915.49.camel@blackbox>
In-Reply-To: <23397_1245442186_n5JK9jDX021038_1245442176.31915.49.camel@blackbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.6.19.220917
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, CELEB_NAMES 0, FROM_EDU_TLD 0, RDNS_BROADBAND 0, RDNS_GENERIC_POOLED 0, RDNS_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RDNS_SUSP_SPECIFIC 0, __BOUNCE_CHALLENGE_SUBJ 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __OEM_PRICE 0, __RDNS_BROADBAND_5 0, __RDNS_POOLED_11 0, __SANE_MSGID 0, __STOCK_PHRASE_7 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen this in Thinkpad T400 and X301 as well.

-Jon


Rajiv Andrade wrote:
> On Tue, 2009-06-16 at 16:49 -0400, Eric Paris wrote:
>   
>> On Mon, 2009-06-15 at 18:42 -0300, Rajiv Andrade wrote:
>>     
>>>> 2- Forget manufacturer_id and base the decision on the PNP_ID as david
>>>> suggested. I previously considered it but since it would end up in
>>>> modifying tpm_tis_init() prototype (struct device * to struct pnp_dev *)
>>>> and then wouldn't work when loading as a module with force option on, so
>>>> I moved to the manufacturer_id approach.
>>>>
>>>> I'll get back to #2 meanwhile and post the patch, seems not hard to
>>>> accomplish though..
>>>>   
>>>>         
>>> Yes, it wasn't hard, at all, just get the id with to_pnp_dev(dev)->id.
>>>
>>> However, the chip is buggy, there's no reason to make a compliant
>>> upstream code modify its behavior just due an 'exception' for a not
>>> compliant hardware.
>>> No need to worry about it too though, the workaround is available as I
>>> pointed earlier (Seiji's)...
>>>       
>> Wait what?  we refuse to work around buggy hardware that is shipping in
>> LOTS of hardware (all the currently shipping lenovo thinkpads) even
>> though the fix is easy?  This doesn't sound right.....
>>     
>
> I didn't refuse to work on it... That depends on the meaning in this
> context. My point is: not make an exception in the upstream code due a
> buggy hardware (that's what that easy 'fix' does). Other than David's
> patches, there is a workaround available as I said: 
>
> http://sourceforge.net/mailarchive/message.php?msg_name=f02dbbe70812012308n32dc9fd6hd1f04d3ef6e002b7%40mail.gmail.com 
>
> The only Lenovo thinkpad model I know that has it is the X200. If Intel
> is indeed still shipping it buggy (therefore more and more unaware users
> are buying it), that's another story. Can you confirm that?
> The best would be to hear something from Intel, if they are planning to
> fix it, discontinue it, do nothing about it or anything else.
> Do you know how to do it or if that's possible?
>
> More, that's only one bug. With the workaround in hands and being able
> to load the module, did you run any regression tests? (Sorry for asking
> that, but, again, I don't have this chip):
>
> Thanks,
> Rajiv
>
>
>
> ------------------------------------------------------------------------------
> Are you an open source citizen? Join us for the Open Source Bridge conference!
> Portland, OR, June 17-19. Two days of sessions, one day of unconference: $250.
> Need another reason to go? 24-hour hacker lounge. Register today!
> http://ad.doubleclick.net/clk;215844324;13503038;v?http://opensourcebridge.org
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>
>   

