Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYJLLbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYJLLbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYJLLbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:31:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46881 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYJLLbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:31:12 -0400
Date: Sun, 12 Oct 2008 07:30:37 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Steven Noonan" <steven@uplinklabs.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Steve French" <sfrench@us.ibm.com>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] cifs: fix build on !CONFIG_KEYS
Message-ID: <20081012073037.20d399ee@tleilax.poochiereds.net>
In-Reply-To: <200810121330.49028.rjw@sisk.pl>
References: <20081012110904.GA581@elte.hu>
	<f488382f0810120414s3c119df5i7737f0ae7304527c@mail.gmail.com>
	<f488382f0810120415k5fa80a0x328a4b0c450b1fd5@mail.gmail.com>
	<200810121330.49028.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 13:30:48 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 12 of October 2008, Steven Noonan wrote:
> > Hmm, which fix is correct though? Depending on KEYS in Kconfig, or
> > adding a nop for it?
> 
> Well, according to git-blame the key_revoke() has been added to fs/cifs/sess.c
> only recently while key_put() was there before.  For this reason I think it's
> correct to handle key_revoke() in analogy with key_put(), ie. add an empty
> definition for it if CONFIG_KEYS is unset.
> 
> Thanks,
> Rafael
> 

Agreed. It should be possible to build CIFS w/o KEYS support. Adding an empty
key_revoke looks like the right thing to do. Looks like Adrian Bunk sent a
patch for this a few hours ago:

    Subject: [2.6 patch] add key_revoke() dummy for KEYS=n

-- 
Jeff Layton <jlayton@redhat.com>
