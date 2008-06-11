Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbYFKPYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbYFKPYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbYFKPYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:24:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:4625 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbYFKPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:24:05 -0400
X-IronPort-AV: E=Sophos;i="4.27,624,1204520400"; 
   d="scan'208";a="559621"
Date: Wed, 11 Jun 2008 16:23:59 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jiri Bohac <jbohac@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console keyboard mapping broken by 04c71976
Message-ID: <20080611152359.GQ4244@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jiri Bohac <jbohac@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20080611134837.GA11462@midget.suse.cz> <20080611140304.GM4244@implementation.uk.xensource.com> <20080611151028.GB11462@midget.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080611151028.GB11462@midget.suse.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 11 Jun 2008 15:23:58.0912 (UTC) FILETIME=[2B8CE400:01C8CBD7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Bohac, le Wed 11 Jun 2008 17:10:28 +0200, a écrit :
> 	...
> 	type = KTYP(keysym);		// 0xfb
> 	...
> 	type -= 0xf0;			// 0xb
>         if (type == KT_LETTER) {	// true
>                 type = KT_LATIN;	// 0
>  
> 	...
>         (*k_handler[type])(vc, keysym & 0xff, !down); 
> 		// calls k_self, note there is really no space for a 
> 		// full unicode representation ;-)

Ah, right, my too-quick look mistook your case with the (type < 0xf0)
case, which does have room for unicode.

Well, in my tests it _was_ working with latin2.  I'll dig more this
evening.

Samuel
