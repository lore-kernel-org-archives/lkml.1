Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbYGQAFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbYGQAFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYGQAFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:05:44 -0400
Received: from namei.org ([69.55.235.186]:52499 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751461AbYGQAFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:05:43 -0400
Date: Thu, 17 Jul 2008 09:56:50 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
Subject: Re: [Patch 5/5]integrity: IMA as an integrity service provider
In-Reply-To: <1216238733.5886.30.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0807170947470.3212@us.intercode.com.au>
References: <20080707192529.489789904@linux.vnet.ibm.com> 
 <1215467789.27626.3.camel@localhost.localdomain> 
 <Xine.LNX.4.64.0807160910470.8360@us.intercode.com.au>
 <1216238733.5886.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008, Mimi Zohar wrote:


> +static ssize_t ima_show_htable_value(char __user *buf, size_t count,
> +				     loff_t *ppos, atomic_t *val)
> +{
> +	char tmpbuf[TMPBUFLEN];
> +	ssize_t len;
> +
> +	len = scnprintf(tmpbuf, TMPBUFLEN, "%i\n", atomic_read(val));
> +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, len);
> +}
> +
> +static ssize_t ima_show_htable_violations(struct file *filp,
> +					  char __user *buf,
> +					  size_t count, loff_t *ppos)
> +{
> +	return ima_show_htable_value(buf, count, ppos, &ima_htable.violations);
> +}


ima_htable.violations is an atomic_long_t and is not safe to pass 
to ima_show_htable_value.  Did you check for compilation warnings?

> +void ima_add_violation(struct inode *inode, const unsigned char *fname,
> +                      char *op, char *cause)
> +{
> +       int result;
> +
> +       /* can overflow, only indicator */
> +       atomic_inc(&ima_htable.violations);

This also generates a warning.  You probably want atomic_long_inc().


- James
-- 
James Morris
<jmorris@namei.org>
