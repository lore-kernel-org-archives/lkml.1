Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXDQVot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXDQVot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965084AbXDQVos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:44:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXDQVor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:44:47 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070417211653.GB11944@one.firstfloor.org>
References: <20070417181016.GA10903@one.firstfloor.org>
	 <657751.18080.qm@web36614.mail.mud.yahoo.com>
	 <20070417211653.GB11944@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 17 Apr 2007 17:41:28 -0400
Message-Id: <1176846088.5946.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 23:16 +0200, Andi Kleen wrote:
> > For SELinux to be effective it has to have a complete policy definition.
> > This would prevent the OpenOffice access (unless OpenOffice is in the
> > modify_resolv_conf_t domain) above.
> 
> This would mean no fully functional root user anymore. My understanding 
> is rather that at least in the Fedora default setup individual applications
> are confined with targetted policy and root left alone because normal system 
> administrators get very unhappy when root becomes powerless.
> 
> I was merely pointing out that in this setup path or namespace based access 
> control are much easier to fit in than label based access because they normally 
> don't require changing applications. John's original document also
> listed some other advantages that I don't need to repeat.
> 

Again - this is incorrect. The vast majority of applications are not
modified to be SELinux aware - only a small handful of security aware
applications are modified. Most labeling is handled transparently by the
policy and more could be handled by the policy if it covered all
processes.

> In "i don't care if it looks like Unix anymore" security setups like
> you're describing that's undoubtedly different and labels might indeed
> work because you forbid just anybody changing them easily. If that makes
> the users happy is a different question though. I suppose it will
> keep security consultants employed at least @)
> 

Unix security is often convenient but it is clear that it is
insufficient.

> Arguably the preserving label issue is not unique to SELinux but 
> also applies to ACLs and other possible uses of EAs, but then people normally 
> don't need to set any ACLs on /etc/resolv.conf.
> 

It also applies to ordinary Unix DAC. Many applications preserve mode
and / or owner bits on files. Think about an editor saves to a temporary
file and renames rather than directly writing the original file name.
For this to work correctly the editor must explicitly preserve DAC mode
bits in addition to ACLs or an SELinux label.

The advantage of using a labeling scheme is, of course, that the data is
always protected even in the temporary file (which might be left around
if the editor crashes) while this is not true for path based security.
Would DAC restrictions be acceptable if renaming a file suddenly allowed
everyone to access that file?

> I personally don't like either too much. Path based access control
> is somewhat hackish and ugly and slow in the current implementation, 
> but I haven't seen an similarly easy to configure solution yet.
> 
> plan9 like limited namespaces for individual processes initially seem 
> like a nice alternative, but in practice they're also too hard to use and 
> suffer from many of the problems the EA label approach has.
> 
> But easy to use security is probably better than complicated security
> because normal people will more likely use it.
> 

I don't think that the ease-of-use issue is clear cut. The hard part of
understanding both SELinux policies and AppArmor profiles is
understanding what access should be allowed. For example, most admins
are hard pressed to know whether OpenOffice should be allowed to
access /dev/random or the security implications of /dev/random
vs /dev/urandom. Whether the access is allowed with the SELinux or
AppArmor language seems like a small issue in comparison. Given that I
think it is better to choose the solution that is complete and capable
of meeting the most security concerns.

I'd also argue that the typical interface presented to admins (which
doesn't involve writing new policies) is easier for SELinux than with
AppArmor. Most admins do fine with relabeling, changing booleans, and
running audit2allow, which is all that is needed to solve the majority
of SELinux issues.

Karl



