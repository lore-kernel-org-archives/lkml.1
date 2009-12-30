Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZL3TtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZL3TtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZL3TtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:49:19 -0500
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:46221 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751701AbZL3TtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:49:18 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 5nyFUC4VM1mHdwQHvPI.92KUCwTLymAX6Cppj9AYka9FWcBYSLnLmc09EAQQK_mi06DTGQq4YQRwMtI2Fz1qQ0_invQQFHRa36ebRzox27mFQQSDOZzHhk4epoEUcy6H6g8RIBZvN2cK0OvjdshFFl8Mp71jDvsJ5Jz9oYDsExg2qOe.suh6MGwp_3Qun5d3NTjCWmotRFWOt2vcW1BS5WXgloWDuAM2_k6HrG92utROzncz_T41eEBj3GeBIEpYcJWmcsjxVGXvS7q0DF2ONHT1thiKxoOV3N6_wYN9kRkusJjsZJv43HEoL1iYXWu31aTLwnkj2UG9oX9GMWQGS4MD7VL2smln69oS__EJtZwJdA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B3BAEB7.3000208@schaufler-ca.com>
Date: Wed, 30 Dec 2009 11:49:11 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Michael Stone <michael@laptop.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: A basic question about the security_* hooks
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat> 	<f73f7ab80912280724l10aef7ber4d4dc8da5aeaafa2@mail.gmail.com> 	<4B395EB8.4050902@schaufler-ca.com> <f73f7ab80912291102i22fb9e10v3b1b0eaba2e4f61d@mail.gmail.com>
In-Reply-To: <f73f7ab80912291102i22fb9e10v3b1b0eaba2e4f61d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Mon, Dec 28, 2009 at 20:43, Casey Schaufler <casey@schaufler-ca.com> wrote:
>   
>> Kyle Moffett wrote:
>>     
>>> On Sat, Dec 26, 2009 at 14:50, Michael Stone <michael@laptop.org> wrote:
>>>       
>>>> I'm willing to entertain pretty much any implementation or interface request
>>>> which meets that goal and which implements the desired semantics.
>>>>
>>>>         
>>> If you aren't using SELinux at this time (and therefore have no
>>> existing policy), then it's actually pretty straightforward
>>> (relatively speaking) to set up for your particular goals.  On top of
>>> that, once you actually get the system set up, it's very easy to
>>> extend your sandbox security model to additional processes, actions,
>>> etc.
>>>
>>> [...]
>>>       
>> I would be very surprised if the policy you've described actually
>> covered all the bases. I would also be surprised if a functional
>> policy that meets the needs described was considerably smaller than
>> Lake Michigan. It's really easy to toss off the basics of what needs
>> to be done, it's quite another to get the whole thing right.
>>
>>     
>>> If all you need is something much simpler, the policy
>>> language is very flexible and easy to customize.
>>>
>>>       
>> I'm willing to bet all the beers you can drink in a sitting that
>> the policy would be bigger than the proposed LSM. You can count that
>> in either bytes or lines.
>>     
>
> If that bet's in Mountain Dew or "Bawls" energy drinks
> (http://www.bawls.com/) instead of beer... then you've got a deal :-D
>   

Hee hee. A sitting doesn't last very long with those beverages.

> Here's a very fast first cut at such a policy.  In this version I
> actually completely ignore the type-enforcement mechanism, although if
> you decide to start mediating file access then you may want to
> reenable it.  The policy is pretty straightforward and easy to read...
> customizations would initially mostly be in the "constraint" rules.
>   

Wouldn't this policy prevent all processes from using the network,
as opposed to the particular ones that need to be controlled?
I can't claim to be the world's greatest policy expert, and I
could have it wrong (it happens often enough) but wouldn't you
need at least two labels, one for the restricted programs and
one for the rest?

> The only thing I actually had to write was the base-policy.pp file.  I
> personally absolutely detest M4... so these particular files are
> designed to be preprocessed with "cpp" instead.  Those 3 ".h" files
> are simply lists of the kernel's access vectors and such run through
> "sed" to convert the "#" comments into "//" comments.
>
> I have a Makefile I've been using personally to build that policy, but
> right now it's rather interdependent with my working environment, so
> it may take me several days to find the time to extract it cleanly.
>
> Cheers,
> Kyle Moffett
>   

