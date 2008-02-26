Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbYBZQlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbYBZQlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYBZQlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:41:25 -0500
Received: from styx.suse.cz ([82.119.242.94]:51360 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753255AbYBZQlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:41:24 -0500
Date: Tue, 26 Feb 2008 17:41:23 +0100
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nix <nix@esperi.org.uk>, Peter Osterlund <petero2@telia.com>,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Jan Kara <jack@ucw.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow:
	ide-cd related? dm-related?
Message-ID: <20080226164123.GB28101@duck.suse.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix> <m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix> <20080225123041.401da103.akpm@linux-foundation.org> <20080225224807.GA15700@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz> <20080226112932.GB10996@elte.hu> <Pine.LNX.4.64.0802261230510.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802261230510.30955@jikos.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-02-08 12:37:17, Jiri Kosina wrote:
> On Tue, 26 Feb 2008, Ingo Molnar wrote:
> 
> > > +	name = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> > > +	fname = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> > > +
> > > +	if (!name || !fname) {
> > > +		*err = -ENOMEM;
> > > +		return NULL;
> > > +	}
> > > +
> > >  	if (dentry) {
> > >  		if (!dentry->d_name.len) {
> > >  			*err = -EINVAL;
> > this bit is missing i think:
> > 	if (name)
> > 		kfree(name);
> > 	if (fname)
> > 		kfree(fname);
> 
> Ergh, of course, stupid me, sorry, it should be freed on all exit paths. I 
> am not sending updated patch, as Jan is probably working on complete 
> removal of one of those fields ... ?
  Yes, I'll convert one variable to kmalloc and the other one remove
completely. Stay tuned ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
