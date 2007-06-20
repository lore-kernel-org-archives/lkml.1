Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXFTOqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXFTOqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXFTOpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:45:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47625 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbXFTOpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:45:52 -0400
Subject: Re: [RFC][Patch 2/3]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, zohar@us.ibm.com, sailer@us.ibm.com
In-Reply-To: <Line.LNX.4.64.0706192217040.19316@localhost.localdomain>
References: <1182199326.8577.6.camel@localhost.localdomain>
	 <Line.LNX.4.64.0706192217040.19316@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 10:48:43 -0400
Message-Id: <1182350923.5688.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 22:18 -0400, James Morris wrote:
> On Mon, 18 Jun 2007, Mimi Zohar wrote:
> 
> 
> > +/* what could we exclude
> > + *   - non-executable/non-library files ?
> > + *   - /proc /dev ?
> > + * Only measure files opened for read-only or execute
> > + */
> > +static int skip_measurement(struct inode *inode, int mask)
> > +{
> > +	if ((inode->i_sb->s_magic == PROC_SUPER_MAGIC) ||
> > +	    (inode->i_sb->s_magic == SYSFS_MAGIC)) {
> > +		return 1;	/*can't measure */
> > +	}
> 
> I'm pretty sure you should skip measurement for many more pseudo 
> filesystems than this.

The LSM module controls what is measured and should only be calling
integrity_measure() for appropriate files.  IBAC, for example, only
calls integrity_measure() for executables from bprm_check_security()
and file_mmap() and for other regular files from inode_permission(), 
based on the existence of the 'security.measure' xattr, which is 
labeled by a userspace application.  The integrity provider, here,
is just doing a quick sanity check, but I'll definitely make it 
more complete and fix the comment to make this clearer.

Thanks!

Mimi

