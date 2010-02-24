Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab0BXUOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:14:07 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39580 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab0BXUOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:14:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iV8kuQAWGEcpRCBYbxg5OQuXtOZfFZCKYhNhEFukb+RF++0+bclw7MODmTXrLwl/R/
         O5O3yblefCPna8n2DjdcEdpk2GQQmc36SqZi2+srfrtOIMSlYQ9qenbARb1wX0yU73H9
         5sapemmkkZz/Oiaezu2zb1SOcCu7hpOmeXQH4=
Date: Wed, 24 Feb 2010 22:13:54 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: paulmck@linux.vnet.ibm.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH 07/10] module: __rcu annotations
Message-ID: <20100224201354.GA3399@core2>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
 <1267041846-10469-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267041846-10469-8-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 09:04:03PM +0100, Arnd Bergmann wrote:
> @@ -360,10 +360,12 @@ struct module *find_module(const char *name)
>  {
>  	struct module *mod;
>  
> -	list_for_each_entry(mod, &modules, list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (strcmp(mod->name, name) == 0)
>  			return mod;
>  	}
> +	rcu_read_unlock();
>  	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(find_module);

modules list is under module_mutex, nothing should be done here.
