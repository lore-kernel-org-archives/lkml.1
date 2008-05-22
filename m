Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYEVCOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYEVCOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 22:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYEVCO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 22:14:27 -0400
Received: from namei.org ([69.55.235.186]:40487 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751414AbYEVCO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 22:14:26 -0400
Date: Thu, 22 May 2008 12:08:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 3/4]integrity: Linux Integrity Module(LIM)
In-Reply-To: <1211385290.20922.27.camel@localhost.localdomain>
Message-ID: <Xine.LNX.4.64.0805221203350.32056@us.intercode.com.au>
References: <1211385290.20922.27.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Mimi Zohar wrote:

> +int register_template(char *template_name,
> +			struct template_operations *template_ops)
> +{
> +	int template_len;
> +	struct template_list_entry *entry;
> +
> +	if (!template_initialized++)
> +		INIT_LIST_HEAD(&integrity_templates);
> +
> +	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
> +	INIT_LIST_HEAD(&entry->template);
> +
> +	template_len = strlen(template_name);
> +	if (template_len > TEMPLATE_NAME_LEN_MAX)
> +		template_len = TEMPLATE_NAME_LEN_MAX;
> +	memcpy(entry->template_name, template_name, template_len);
> +	entry->template_name[template_len] = '\0';
> +	entry->template_ops = template_ops;
> +	list_add(&entry->template, &integrity_templates);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_template);

There's no locking around the mainpulation of integrity_templates list.  
It seems that this could lead to list corruption.



- James
-- 
James Morris
<jmorris@namei.org>
