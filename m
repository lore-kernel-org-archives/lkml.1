Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZKIPhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZKIPhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZKIPhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:37:23 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:56443 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbZKIPhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:37:22 -0500
MIME-Version: 1.0
In-Reply-To: <1257292099-15802-3-git-send-email-john.johansen@canonical.com>
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com>
	 <1257292099-15802-3-git-send-email-john.johansen@canonical.com>
Date: Mon, 9 Nov 2009 10:37:27 -0500
Message-ID: <7e0fb38c0911090737i35173bbla07dcf539cd5791c@mail.gmail.com>
Subject: Re: [PATCH 02/12] AppArmor: basic auditing infrastructure.
From: Eric Paris <eparis@parisplace.org>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 6:48 PM, John Johansen
<john.johansen@canonical.com> wrote:
> Update kenel audit range comments to show AppArmor's registered range of
> 1500-1599.  This range used to be reserved for LSPP but LSPP uses the
> SELinux range and the range was given to AppArmor.
> Patch is not in mainline -- pending AppArmor code submission to lkml
>
> Add the core routine for AppArmor auditing.
>
> Signed-off-by: John Johansen <john.johansen@canonical.com>

As the audit maintainer I NAK.  I NAK any patch that calls
audit_log_format() with %s.  Use an audit_log_string() function unless
you can prove to me it meets all of the audit string handling rules
(and you know them).  That part isn't too hard to fix but....

I'd like to register an objection to this patch as a whole.  I know
it's a pain and its probably going to take a little reshaping of your
userspace tools that ran against your out of tree patches, but we get
a lot of work for free if you would make use of the lsm_audit.{c,h}
file instead of redoing everything.  Extend it as you need to the same
way that SMACK and SELinux did.  Personally I think it needs a generic
lsm=%s (SMACK does it in smack_log_callback, SELinux doesn't do it but
could/should)

I don't think we want to use more AUDIT messages for the same thing
even if someone in userspace said you could a long time ago.

LSM unification and code sharing is a good thing, even if the LSMs
can't agree on much else  :)

-Eric
