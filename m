Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbYJSWwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbYJSWwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYJSWwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:52:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:15696 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYJSWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=QbBtqCXBvJAIieOOxhIw4S1MyNeTUZAB7dsb6Bvhr4/GVbYVwFbnlZVtvMbCYbhOo5
         862pqf21bkbzyMNv12EER6dEBQU6J1ZqPI0m+hK9Mese2HCbi1ofAie4ldBPI9TUmQWc
         oMaKPbQJ1bsdht+uW7RpOImoouFyyd1g6Zofo=
Message-ID: <cb0375e10810191552l7541e034l6f1e095c0c268baa@mail.gmail.com>
Date: Sun, 19 Oct 2008 18:52:03 -0400
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: iwlagn: associating with AP causes kernel hiccup
Cc: richard@scherping.de, "Frederik Himpe" <fhimpe@telenet.be>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1ba2fa240810191512i4c6ce748kd13d1671cc2a2ff6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>
	 <gd9v3f$3ft$1@ger.gmane.org> <gd9vpo$5ql$1@ger.gmane.org>
	 <48F8AEF1.5030603@scherping.de>
	 <1ba2fa240810171302h7dcc92acr18c060425c4a93d@mail.gmail.com>
	 <48FA0C27.8010301@scherping.de> <48FB4FBE.2060909@myrealbox.com>
	 <1ba2fa240810191512i4c6ce748kd13d1671cc2a2ff6@mail.gmail.com>
X-Google-Sender-Auth: 425c2a42022e0fea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 6:12 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Sun, Oct 19, 2008 at 5:18 PM, Andy Lutomirski <luto@myrealbox.com> wrote:
>> Richard Scherping wrote:
>>>
>>> Tomas Winkler schrieb:
>
>>
>> Amen.
> Stable doesn't mean all components are stable, citation  from Linus blog:
> "It doesn't have to be perfect (and obviously no release ever is), but
> it needs to be in reasonable shape"
>
> The fact is that some critical patches were rejected as not
> regressions in rc cycle and probably need to be pushed to the stable
> version now or distribution will merge them.
> We gave more priority for testing 32 bit version so it is more stable
> then 64 bit which got much less in house testing and we've missed many
> issues there. The driver doesn't get full exposure till it's get to
> the public in stable version therefore  no bugs are opened in the rc
> cycle so also are not fixed in the stable version. and unfortunately
> there is no much system testing at all for what get's into merging
> window.
> Second the whole mac80211 stack didn't address fully MQ rewrite so
> it's a bit shaky as well and this will be fact also in 2.6.28.

OK.

>
> This driver has been available and more-or-less working for ages.
>> What kernel am I supposed to run if I just want a stable system? Haven't
>> found one yet, other than distro kernels...
>>
>> In any case, I've seen these complete system hiccups with iwl4965 and iwlagn
>> since at least 2.6.25 and through quite a few wireless-testing versions.  I
>> bet that this, along with things like it, is the culprit:
>
> Haven't seen you've filled bug for it.

Fair enough.  #1790.

>
> Locking need to be really revised but till now I didn't see show
> stoppers issues so it didn't get priority
>
>> Would I be out of line for wishing the iwlwifi developers
> Patches are always welcome

I can write a patch to add a mutex and change it to:

take mutex
grab_nic
spinlock

but I bet that would break all kinds of things. :)

--Andy
