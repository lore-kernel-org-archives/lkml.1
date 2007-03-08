Return-Path: <linux-kernel-owner+w=401wt.eu-S1750735AbXCHK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750735AbXCHK0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 05:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXCHK0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 05:26:15 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33081 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750735AbXCHK0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 05:26:14 -0500
Message-ID: <373349571.06906@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 8 Mar 2007 18:25:50 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       John Tran <jbtran@ca.ibm.com>, Mike Sullivan <mksully@us.ibm.com>,
       Chris Mason <mason@suse.com>, Steven Pratt <slpratt@austin.ibm.com>,
       Badari Pulavarty <badari@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] readahead: partial sendfile fix
Message-ID: <20070308102549.GA5908@mail.ustc.edu.cn>
Mail-Followup-To: Ram Pai <linuxram@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suparna Bhattacharya <suparna@in.ibm.com>,
	John Tran <jbtran@ca.ibm.com>, Mike Sullivan <mksully@us.ibm.com>,
	Chris Mason <mason@suse.com>, Steven Pratt <slpratt@austin.ibm.com>,
	Badari Pulavarty <badari@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070210014049.GA11269@mail.ustc.edu.cn> <1171309751.2891.70.camel@ram.us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171309751.2891.70.camel@ram.us.ibm.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram Pai,

Sorry for the long delay, I was just back from the winter vacation.

On Mon, Feb 12, 2007 at 11:49:10AM -0800, Ram Pai wrote:
> The solution you proposed seems kludgy to me. If you determine that the

I dislike it, either.

> its a restarted aio, then start reading from where readahead had left
> reading from earlier. To me a simple fix is:
> 
> -       if (unlikely(aio_restarted()))
> -               next_index = last_index; /* Avoid repeat readahead */
> 
> +       if (unlikely(aio_restarted()))
> +  		next_index = min(prev_index+1, last_index);
> 
> 
> No? 

Can be even simpler, if we _only_ want to fix the aio case:

+       if (unlikely(aio_restarted()))
+               next_index = prev_index + 1;

Regards,
Wu
