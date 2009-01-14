Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbZANVfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbZANVfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZANVfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:35:32 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:51222 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZANVfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:35:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hGslpHUMdK8LJmMiCP3fL1cAnbp9tZAXDneli8mm+pmT4pVdL95bDDPCew1OQaHZOT
         hqHWr7PwFf5esJwM3EkUZg89xdhh8etyZbxa6nn4ddlcT81db50i+BCPZuw+jV2eB25U
         +TQG/8oUpykrnJkUtuv/bhuh3vt3rM2MOXbQ4=
Message-ID: <496E5A9D.3050105@gmail.com>
Date: Wed, 14 Jan 2009 13:35:25 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       SE-Linux <selinux@tycho.nsa.gov>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
References: <496D759A.7010401@gmail.com> <496E21B3.3070206@gmail.com> <200901141504.30674.paul.moore@hp.com> <200901141508.58174.paul.moore@hp.com>
In-Reply-To: <200901141508.58174.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Wednesday 14 January 2009 3:04:30 pm Paul Moore wrote:
>   
>> On Wednesday 14 January 2009 12:32:35 pm Justin P. Mattock wrote:
>>     
>
> ...
>
>   
>>>>> The next is a macbookpro ati chipset the kernel is 2.6.29-rc1
>>>>> the o.s. is ubuntu jaunty, the netlabel_tools is the same as
>>>>> above. the only results I see out of this is the avc's it's
>>>>> generating (the allow rules above are from the macbook);
>>>>> some reason the dell doesn't generate any avc's,
>>>>> which makes me wonder is this a module issue.
>>>>>           
>>>> Huh.  Just so I'm clear on this ... on the macbook you see avc
>>>> denials that correspond to the allow rules you posted above, but
>>>> on the dell you don't see the same avc denials?  Are you running
>>>> the same SELinux policy on both systems (version numbers)?  What
>>>> is the output of the following command on both systems?
>>>>
>>>>  # cat /selinux/policy_capabilities/network_peer_controls
>>>>         
>>> for both systems I'm running the refpolicy(svn) from tresys.
>>> the new ubac options, and newrole mechanism etc..
>>> doing cat /selinux/policy_capabilities_netowork_peer_controls says
>>> "1" should be for both.
>>>       
>> Ahhhh!  How did that happen?!  (see my response to your other email)
>>     
>
> Sorry, just realized your other email was private.  In case anyone else 
> is following this thread, the SELinux policy for network_peer_controls 
> policy capability is still a work in progress and is disabled by 
> default because there are still a few issues remaining.  Disabling the 
> network_peer_controls (the default configuration) fixed the problem.
>
>   
Cool, that's what I figured when looking at cipsov4.
As for the namespace term(yeah I don't know the term; ahh different
domain's or mappings I think);
Anyways heres what I'm trying to achieve:

default looks like this:
Configured NetLabel domain mappings(1)
domain: DEFAULT
    protocol: UNLABELED

I want to try and have three of these for the
different types of media:
(in theory)
Configured NetLabel domain mappings(3)
domain:radio
   protocol: UNLABELED
domain:T.V.
   protocol: UNLABELED
domain:web
   protocol: UNLABELED
(and if possible three different tags(either 1,2,5), but probably can
only do that with cipsov4);

heres what I've come up with so far:

netlabelctl -p map del default

netlabelctl unlbl add domain:radio interface:wlan0 address:<myadd> 
label:system_u:object_r:netlabel_peer_t:s0
netlabelctl unlbl add domain:radio interface:wlan0 address:<radioadd> 
label:system_u:object_r:netlabel_peer_t:s0

netlabelctl unlbl add domain:T.V. interface:wlan0 address:<myadd> 
label:system_u:object_r:netlabel_peer_t:s0
netlabelctl unlbl add domain:T.V. interface:wlan0 address:<t.v.add> 
label:system_u:object_r:netlabel_peer_t:s0

As for the new capabilities, I don't mind trying that out when
the time comes(but first I need to figure the this out before any other 
ways);

here is what the error looks like:

netlabel_tools-0.19# make
INFO: creating the version header file
.: 10: version_info: not found
make: *** [include/version.h] Error 2

(googling for the missing package results in a bunch of
hits on "just do a uname -r");

In any case using the default, and then just adding
addresses is probably fine for the time being.

regards;

Justin P. Mattock



