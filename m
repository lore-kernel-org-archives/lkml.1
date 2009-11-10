Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbZKJSi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbZKJSi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZKJSi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:38:26 -0500
Received: from adelie.canonical.com ([91.189.90.139]:33953 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbZKJSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:38:25 -0500
Message-ID: <4AF9B323.8050401@canonical.com>
Date: Tue, 10 Nov 2009 10:38:27 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 02/12] AppArmor: basic auditing infrastructure.
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com>	 <1257292099-15802-3-git-send-email-john.johansen@canonical.com> <7e0fb38c0911090737i35173bbla07dcf539cd5791c@mail.gmail.com>
In-Reply-To: <7e0fb38c0911090737i35173bbla07dcf539cd5791c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Tue, Nov 3, 2009 at 6:48 PM, John Johansen
> <john.johansen@canonical.com> wrote:
>> Update kenel audit range comments to show AppArmor's registered range of
>> 1500-1599.  This range used to be reserved for LSPP but LSPP uses the
>> SELinux range and the range was given to AppArmor.
>> Patch is not in mainline -- pending AppArmor code submission to lkml
>>
>> Add the core routine for AppArmor auditing.
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
> 
> As the audit maintainer I NAK.  I NAK any patch that calls
> audit_log_format() with %s.  Use an audit_log_string() function unless
> you can prove to me it meets all of the audit string handling rules
> (and you know them).  That part isn't too hard to fix but....
> 
> I'd like to register an objection to this patch as a whole.  I know
> it's a pain and its probably going to take a little reshaping of your
> userspace tools that ran against your out of tree patches, but we get
> a lot of work for free if you would make use of the lsm_audit.{c,h}
> file instead of redoing everything.  Extend it as you need to the same
> way that SMACK and SELinux did.  Personally I think it needs a generic
> lsm=%s (SMACK does it in smack_log_callback, SELinux doesn't do it but
> could/should)
> 
> I don't think we want to use more AUDIT messages for the same thing
> even if someone in userspace said you could a long time ago.
> 
> LSM unification and code sharing is a good thing, even if the LSMs
> can't agree on much else  :)
> 
>
yes that will be a pain but if that is what is needed then we will have
to live with it.  However there is a caveat, that I need to look into yet,
all apparmor loggin will necessarily go through the audit subsystem.

We are planning our own dedicated netlink interface and dumping high volume
complain (learning) mode messages to it if an external application is
registered.  I pretty sure we can make it work but I just haven't looked
at it enough yet.

thanks
john

