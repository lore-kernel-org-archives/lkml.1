Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZBCOAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZBCOAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBCOAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:00:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43214 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZBCOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:00:19 -0500
Date: Tue, 3 Feb 2009 08:03:42 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: david safford <safford@watson.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/6] integrity: IMA as an integrity service provider
Message-ID: <20090203140342.GA22458@hallyn.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com> <eae67eb66b76df32f0e95c4cda33fd6271567c94.1233262163.git.zohar@linux.vnet.ibm.com> <20090202230211.GA18452@hallyn.com> <1233668170.4263.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233668170.4263.24.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting david safford (safford@watson.ibm.com):
> On Mon, 2009-02-02 at 17:02 -0600, Serge E. Hallyn wrote:
> > Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > > +
> > > +/* Add template entry to the measurement list and hash table,
> > > + * and extend the pcr.
> > > + */
> > > +int ima_add_template_entry(struct ima_template_entry *entry, int violation,
> > > +			   const char *op, struct inode *inode)
> > > +{
> > > +	u8 digest[IMA_DIGEST_SIZE];
> > > +	const char *audit_cause = "hash_added";
> > > +	int audit_info = 1;
> > > +	int result = 0;
> > > +
> > > +	mutex_lock(&ima_extend_list_mutex);
> > > +	if (!violation) {
> > > +		memcpy(digest, entry->digest, sizeof digest);
> > > +		if (ima_lookup_digest_entry(digest)) {
> > > +			audit_cause = "hash_exists";
> > > +			goto out;
> > 
> > Ok so not that I'm saying this would be easy, but an attacker
> > compromising say ftpd doesn't need to come up with a compromised
> > ftpd where sha1sum(evilftpd)==sha1sum(origftpd) - he just needs to
> > come up with one wher sha1sum(evilftpd)==sha1sum(X) where X is
> > any pristine program already loaded.  Right?
> > 
> > Is checking that strcmp(entry->file_name, newfilename)==0 warranted
> > here, or am I being silly?
> 
> The birthday paradox, which is essential for any practical attack,
> requires that the attacker can freely choose both x and y in 
> his search for collisions sha1sum(x) == sha1sum(y). Here, the
> attacker cannot freely choose x,

That's why I said a forward-looking attacker.  He can, in fact,
choose x.

>  but can only choose x from a list
> of existing files. Even if there are a million valid files, that only
> reduces the attack complexity by 2^20, which is still infeasible.
> 
> dave
