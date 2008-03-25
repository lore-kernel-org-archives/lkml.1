Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYCYLaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYCYLaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYCYL3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:29:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:46347 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYCYL3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:29:51 -0400
Message-ID: <47E8E227.7040105@mev.co.uk>
Date: Tue, 25 Mar 2008 11:29:43 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080317)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Corrections to Documentation/rbtree.txt
References: <47E282F5.6090703@mev.co.uk> <200803201339.18618.rob@landley.net>
In-Reply-To: <200803201339.18618.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2008 11:29:44.0895 (UTC) FILETIME=[867B94F0:01C88E6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/08 18:39, Rob Landley wrote:
> On Thursday 20 March 2008 10:29:57 Ian Abbott wrote:
>> From: Ian Abbott <abbotti@mev.co.uk>
>>
>> The description of the rb_entry() macro in Documentation/rbtree.txt seems
>> incorrect. This patch improves it (hopefully).  Also I changed the example
>> code to call the previous 'my_search()' example instead of an undefined
>> 'mysearch()'.
> 
> I have no objection to the patch (and the my_search thing seems like an 
> obvious typo), but is there a reason to prefer rb_entry() rather than 
> container_of()?  If so, the rationale might be a good thing to add to the 
> documentation...

I forgot to mention this in my earlier post, but while we're on the
subject, it might be worth renaming the 'node' variable in the
'my_search()' and iteration examples to avoid confusion in the use of
the rb_entry() (or container_of() macro), for example in 'my_search()',
instead of:

	struct rb_node *node = root->rb_node;

	while (node) {
		struct mytype *data = rb_entry(node, struct mytype, node);

I think this is clearer:

	struct rb_node *pn = root->rb_node;

	while (pn) {
		struct mytype *data = rb_entry(pn, struct mytype, node);

(I used rb_entry instead of container_of in the above.  Also, there are
probably better, longer variable names than 'pn', e.g. 'rbn' or 'rbnode'
or 'pnode'.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
