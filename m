Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYGDN5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYGDN5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYGDN5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:57:43 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:50562 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYGDN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=O1txIgpJ9da4/jVCavX7czokHFJ3mJvieD4OeR7ZfUEoGx6nbr6aGsbm6tgCl9ycUE
         d94E50TZq5Qfj86N8nf3+dsrnelLTzcUTkZbsWLz1GpLrSRY/fjouGrQbR1/F6xEMpEW
         LGOZ54fHJxKXLtPdJW6XkDRemwcJ+u6Q+QFA0=
Message-ID: <486E2C3B.6020603@gmail.com>
Date: Fri, 04 Jul 2008 22:57:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Benjamin Thery <benjamin.thery@bull.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] driver core: Implement tagged directory support
 for device classes.
References: <20080618170729.808539948@theryb.frec.bull.fr>	<m14p78s02q.fsf@frodo.ebiederm.org> <486C4515.1070007@gmail.com>	<m1hcb7o8lv.fsf@frodo.ebiederm.org> <486CB051.5000507@fr.ibm.com>	<m14p77m9uy.fsf@frodo.ebiederm.org> <486CF71F.5090405@gmail.com>	<m1y74iiidz.fsf_-_@frodo.ebiederm.org>	<m1tzf6ihlz.fsf_-_@frodo.ebiederm.org>	<m1prpuihjb.fsf_-_@frodo.ebiederm.org>	<m1lk0iihhp.fsf_-_@frodo.ebiederm.org>	<m1hcb6ihfz.fsf_-_@frodo.ebiederm.org>	<m1d4luihea.fsf_-_@frodo.ebiederm.org>	<m18wwiihbn.fsf_-_@frodo.ebiederm.org>	<m14p76ih9a.fsf_-_@frodo.ebiederm.org>	<m1zloyh2mb.fsf_-_@frodo.ebiederm.org>	<m1vdzmh2jr.fsf_-_@frodo.ebiederm.org>	<m1r6aah2hh.fsf_-_@frodo.ebiederm.org>	<m1mykyh2fu.fsf_-_@frodo.ebiederm.org>	<m1hcb6h2d2.fsf_-_@frodo.ebiederm.org> <486DD650.3000804@gmail.com> <m1tzf593ny.fsf@frodo.ebiederm.org>
In-Reply-To: <m1tzf593ny.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
> Thank you for your opinion.
> 
> Incremental patches to make things more beautiful are welcome.
> 
> Please remember we are not building lisp.  The goal is code that works today.
> 
> Since we are not talking about correctness of the code.  Since we are not
> talking about interfaces with user space.  Since we are talking something
> that is currently about 100 lines of code, and so will be easy to change
> even after it is merged.   I don't understand how discussing this further
> is useful.  Especially when I get a NAK  based on the feel that the code
> is ugly.

I'm sorry if I gave you the impression of being draconian.  Explanations
below.

> As for your main objection.  Adding a accessor method to an object versus
> adding a data field that contain the same thing.  The two are effectively
> identical.  With the practical difference in my eyes that an accessor method
> prevents data duplication which reduces maintenance and reduces skew problems,
> and it keeps the size of struct kobject small.  Since you think methods are
> horrible I must respectfully disagree with you.

Yeah, it seems we should agree to disagree here.  I think using callback
for static values is a really bad idea.  It obfuscates the code and
opens up a big hole for awful misuses.  Greg, what do you think?

As we're very close to rc1 window, I think we can work out a solution
here.  The reason why I nack'd was because the change wouldn't take too
much effort and I thought it could be done before -rc1.  Unless you
disagree with making tags static values, I'll try to write up a patch to
do so.  If you (and Greg) think the callback interface is better, we can
merge the code as-is and update (or not) later.

Thanks.

-- 
tejun
