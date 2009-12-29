Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbZL2Bn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbZL2Bn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 20:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZL2Bn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 20:43:27 -0500
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:25366 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751416AbZL2Bn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 20:43:26 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: QX9_EcgVM1nhFEfRKkgTJlBIqKkRh56HKsWlBkWICy3jGRYG9cL7pwciYQolGTeQV6iYjL_3pwikz34TE1LvREBvp97vgcdgM0pkd6GjxGBvhE9ukN5usEDDTvCbyo7Lf1OrbhHRD7nMfqyv4xhWKFP_AyFT.DCqwfDtFlQKAAsY77bo9WrfDMDwgK6iq4wLxjgaistdiHuY0AmNMVtbTy9i3qrH3.MG0GFzsxM.1nEqYcsMpCXY8iNcWWHC4CxZTNHyYWOE0oYXvSbvFJbab0GF1T7jpYfkVH.GTkVzHfNjq9VUWNi712wyJ0ymkuTk5mC8FMtyQk1.4AjNvp13b7mab7T5Ji0s9iQ_6IYKaSMFZSzoOAbDfma7rjvEPhJSB_D9JKD6Ha3qF3Zulgu8kM8S61PmYNkSAgBLtA1bqn2DVEkOOmaNX_tHZghmZhKzLGd6byfQ8sX4UgOFLBuI4F7IAs0fuGY-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B395EB8.4050902@schaufler-ca.com>
Date: Mon, 28 Dec 2009 17:43:20 -0800
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
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat> <f73f7ab80912280724l10aef7ber4d4dc8da5aeaafa2@mail.gmail.com>
In-Reply-To: <f73f7ab80912280724l10aef7ber4d4dc8da5aeaafa2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> On Sat, Dec 26, 2009 at 14:50, Michael Stone <michael@laptop.org> wrote:
>   
>>> I ask bc the API is in the prctl code, so the LSM
>>> is conceptually always there, which is different from other LSMs.
>>>       
>> The goal is to provide a stupidly simple unprivileged per-process network
>> isolation primitive which is broadly available "without jumping through
>> hoops".
>>
>> (See http://cr.yp.to/unix/disablenetwork.html for a nice writeup.)
>> I need a primitive like this to further my work on the OLPC Bitfrost
>> security
>> architecture and to further my more general work on advancing the state of
>> sandboxing technology. (See sandboxing.org.)
>>
>> I'm willing to entertain pretty much any implementation or interface request
>> which meets that goal and which implements the desired semantics.
>>     
>
> If you aren't using SELinux at this time (and therefore have no
> existing policy), then it's actually pretty straightforward
> (relatively speaking) to set up for your particular goals.  On top of
> that, once you actually get the system set up, it's very easy to
> extend your sandbox security model to additional processes, actions,
> etc.
>
> In this example, you would set up a very minimal stripped-down SELinux
> policy in which you only define 3 types (file_t, regular_t and
> nonetwork_t).  Any process would be allowed to "dyntransition" from
> regular_t to nonetwork_t, but not the reverse.  regular_t would be
> allowed to do anything.  nonetwork_t would be allowed to do anything
> that (A) does not involve the network *and* (B) does not compromise a
> regular_t process.  file_t would only be used for on-disk files.
>
> If you want to have some program binaries *automatically* run in
> nonetwork_t, you would add 1 extra type: nonetwork_exec_t.  You would
> include a rule "type_transition regular_t nonetwork_exec_t:process
> nonetwork_t;" in your policy, and then allow anyone to relabel files
> between the labels "file_t" and "nonetwork_exec_t".  Any program file
> labelled "nonetwork_exec_t" would automatically execute as
> "nonetwork_t" and therefore be properly sandboxed.
>   

I would be very surprised if the policy you've described actually
covered all the bases. I would also be surprised if a functional
policy that meets the needs described was considerably smaller than
Lake Michigan. It's really easy to toss off the basics of what needs
to be done, it's quite another to get the whole thing right.

> The default SELinux policies are rather fantastically complicated,
>   

Everyone, I didn't say that. He did.

> mainly because they have a goal of locking down an entire GUI-enabled
> system.  

Err, even with unconstrained_t all over the place it's over a million
lines. You can't blame the GUI environment for that.

> If all you need is something much simpler, the policy
> language is very flexible and easy to customize.
>   

I'm willing to bet all the beers you can drink in a sitting that
the policy would be bigger than the proposed LSM. You can count that
in either bytes or lines.

> The best part is... when you discover you need to control additional
> actions, you can do so at runtime with zero risk of crashing the
> kernel (although you can always lock yourself into a box and force a
> reboot with bad security policy).
>
> Cheers,
> Kyle Moffett
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

