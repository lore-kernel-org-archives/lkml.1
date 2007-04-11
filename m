Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXDKSaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXDKSaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXDKSaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:30:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47083 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXDKSaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:30:07 -0400
Subject: Re: [patch 0/8] unprivileged mount syscall
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu>
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu>
	 <20070409143802.GB4891@sergelap.austin.ibm.com>
	 <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu>
	 <20070409170743.GF24415@sergelap.austin.ibm.com>
	 <E1Hb0CH-0000nX-00@dorka.pomaz.szeredi.hu>
	 <1176194285.2903.67.camel@ram.us.ibm.com>
	 <E1HbaJV-00059N-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 11:28:36 -0700
Message-Id: <1176316116.2811.39.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 12:44 +0200, Miklos Szeredi wrote:
> > 1. clone the master namespace.
> > 
> > 2. in the new namespace
> > 
> > 	move the tree under /share/$me to /
> >         for each ($user, $what, $how) {
> >             move /share/$user/$what to /$what
> > 	    if ($how == slave) {
> >                  make the mount tree under /$what as slave
> >             }
> >         }
> >         
> > 3. in the new namespace make the tree under 
> >        /share as private and unmount /share
> 
> Thanks.  I get the basic idea now: the namespace itself need not be
> shared between the sessions, it is enough if "share" propagation is
> set up between the different namespaces of a user.
> 
> I don't yet see either in your or Viro's description how the trees
> under /share/$USER are initialized.  I guess they are recursively
> bound from /, and are made slaves.

yes. I suppose, when a userid is created one of the steps would be

mount --rbind / /share/$USER
mount --make-rslave /share/$USER
mount --make-rshared /share/$USER

RP







> Miklos

