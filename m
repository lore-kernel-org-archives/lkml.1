Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZEIDU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZEIDU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZEIDUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:20:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:51078 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZEIDUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:20:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oOF1OubwoFf6sB6gipVspb32rIdN5zuGHsfibcnYQ9JKjyNuqtkaXjJhaYRkqKxnx3
         rU0h4Y3cwKnMnbxfwHD4FmD0s9nXfTLA/deK4OmksW8NNZOgGEnunCuFopPUUupubr2L
         EdwpdwnvGE+Qk/DkyVczH+0A4kdAppCHV+1QI=
Message-ID: <4A04F5D7.2050909@gmail.com>
Date: Fri, 08 May 2009 23:17:43 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Eric Paris <eparis@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, serue@us.ibm.com, hpa@zytor.com,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single andmultiple-instancemounts
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com> <20090507212429.GA24064@linux.vnet.ibm.com> <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com> <20090507231844.GA27609@linux.vnet.ibm.com> <20090507232110.GB27609@linux.vnet.ibm.com>
In-Reply-To: <20090507232110.GB27609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2009 07:21 PM, Sukadev Bhattiprolu wrote:
> Er. I meant add following lines after the memset().
>
> |         opts->mode    = DEVPTS_DEFAULT_MODE;
> |         opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;

Adding those two lines (with . instead of ->) does fix the issue for me, 
thanks.

| > Of course we would still need to understand if/
| > why this patch changes the settings.

That particular patch changed things because the original memcpy in 
new_pts_mount() did this:

memcpy(&fsi->mount_opts, opts, sizeof(opts));

where opts was a pointer, not a structure.  So only the first few bytes 
of the blank opts actually got copied over.  The patch moved this memcpy 
to devpts_get_sb() and in the process fixed the sizeof error.

Marc
