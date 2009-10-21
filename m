Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbZJUTaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbZJUTaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZJUTaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:30:02 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:24747 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbZJUT37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:29:59 -0400
Date: Wed, 21 Oct 2009 13:30:02 -0600
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: add numa node symlink for cpu devices in sysfs
Message-ID: <20091021193002.GI14102@ldl.fc.hp.com>
References: <20091019212740.32729.7171.stgit@bob.kio> <20091019213430.32729.78995.stgit@bob.kio> <alpine.DEB.1.00.0910192016010.25264@chino.kir.corp.google.com> <20091020204136.GB23675@ldl.fc.hp.com> <alpine.DEB.1.00.0910201407190.27248@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.1.00.0910201407190.27248@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com>:
> On Tue, 20 Oct 2009, Alex Chiang wrote:
> > * David Rientjes <rientjes@google.com>:
> > > The return values of register_cpu_under_node() and 
> > > unregister_cpu_under_node() are always ignored, so it would probably be 
> > > best to convert these to be void functions.  That doesn't mean you can 
> > > simply ignore the result of the first sysfs_create_link(), though: the 
> > > second should probably be suppressed if the first returns an error.
> > 
> > I didn't want to change too much in the patch. Changing the
> > function signature seems a bit overeager, but if you have strong
> > feelings, I can do so.
> 
> It's entirely up to you if you want to change them to be void.  I thought 
> it would be cleaner if the first patch in the series would convert them to 
> void on the basis that the return value is never actually used and then 
> the following patches simply return on error conditions.

I made the conversion as you suggested, but discovered under
sparse that:

	drivers/base/node.c: In function ‘register_cpu_under_node’:
	drivers/base/node.c:245: warning: ignoring return value of
	‘sysfs_create_link’, declared with attribute warn_unused_result

I wasn't very happy with the result after doing something with
the return value of sysfs_create_link to make sparse shutup.
Seemed unnatural and very much had the feeling of jumping through
hoops just to make an automated tool be quiet.

So, I'll just leave [un]register_cpu_under_node() as returning
int. It not only makes the patch feel better, but if we do ever
want to decide to unroll due to an error in sysfs_create_link,
we'll have the information available at the callsites.

Thanks.
/ac

