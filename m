Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYHFOS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYHFOS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYHFOSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:18:18 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:26850 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbYHFOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:18:17 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Date: Wed, 6 Aug 2008 10:18:06 -0400
User-Agent: KMail/1.9.7
Cc: Cliffe <cliffe@ii.net>, Eric Paris <eparis@redhat.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <1217883616.27684.19.camel@localhost.localdomain> <200808051656.28231.paul.moore@hp.com> <489913CF.1010708@schaufler-ca.com>
In-Reply-To: <489913CF.1010708@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061018.06110.paul.moore@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 11:00:31 pm Casey Schaufler wrote:
> Paul Moore wrote:
> > On Monday 04 August 2008 11:44:28 pm Casey Schaufler wrote:
> >> Cliffe wrote:
> >>> Other security schemes such as intrusion detection,
> >>> firewalls/netfilter, anti-malware, and application restrictions
> >>> (sandboxes such as jails or finer grained restrictions such as
> >>> AppArmor) could all register LSMs onto the stack.
> >>
> >> Stacking is easy for files. It's a real pain in the backside for
> >> UDP packets.
> >
> > How is it any better/worse for UDP packets than files?
>
> On delivery you'd need to decide what security scheme is actually
> available on the packet and in what order to interpret any inbound
> security data. If you had an MLS scheme that uses CIPSO, an integrity
> mechanism using IPSEC and a DAC scheme that assigns user ids by
> host address getting the ordering right and every domain registered
> properly in the networking stack would be a trick.

I still don't understand how that is any different from a file or some 
other resource, local or remote.  Assuming a single security label 
(tag, mark, mode, etc.) on an entity on which you wish to apply an 
access control decision the problem boils down to how do you 
internalize the security label in such a way that it can be useful for 
the security mechanism(s).  In the case of a single LSM you do this 
once, in the case of multiple, stacked LSMs you do this multiple times.

With multiple security markings on an entity then you have to decide if 
you want to consider every marking at each LSM instance, or a subset.  
The complexity in this case does go up dramatically, but I think the 
key point for our discussion is that it doesn't matter if the entity is 
a file or a packet.

> Plus, making sure 
> that any state the security scheme requires is tricky. Maybe it's not
> actually worse if the schemes agree on what qualifies as a security
> element, but if one scheme does access control outbound while another
> does inbound it will get hairy.

Once again, these points apply equally to files as they do to packets.

-- 
paul moore
linux @ hp
