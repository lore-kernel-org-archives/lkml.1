Return-Path: <linux-kernel-owner+w=401wt.eu-S1761137AbYBZLaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137AbYBZLaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYBZLaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:30:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYBZLaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:30:06 -0500
Date: Tue, 26 Feb 2008 12:29:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Nix <nix@esperi.org.uk>, Peter Osterlund <petero2@telia.com>,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Jan Kara <jack@ucw.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow:
	ide-cd related? dm-related?
Message-ID: <20080226112932.GB10996@elte.hu>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix> <m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix> <20080225123041.401da103.akpm@linux-foundation.org> <20080225224807.GA15700@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> +	name = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> +	fname = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> +
> +	if (!name || !fname) {
> +		*err = -ENOMEM;
> +		return NULL;
> +	}
> +
>  	if (dentry) {
>  		if (!dentry->d_name.len) {
>  			*err = -EINVAL;

this bit is missing i think:

	if (name)
		kfree(name);
	if (fname)
		kfree(fname);

	Ingo
