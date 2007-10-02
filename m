Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXJBLwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXJBLwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXJBLwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:52:35 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37548 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXJBLwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:52:34 -0400
Date: Tue, 2 Oct 2007 13:52:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Giuliano Gagliardi <gogi-k@gogi.tv>
cc: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
In-Reply-To: <200710021339.31332.gogi-k@gogi.tv>
Message-ID: <Pine.LNX.4.64.0710021349440.7130@fbirervta.pbzchgretzou.qr>
References: <200710021256.08469.gogi-k@gogi.tv> <200710021333.05826.gogi-k@gogi.tv>
 <Pine.LNX.4.64.0710021334130.7130@fbirervta.pbzchgretzou.qr>
 <200710021339.31332.gogi-k@gogi.tv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 2 2007 13:39, Giuliano Gagliardi wrote:
>>
>> You could write up a LSM that restricts UID changing.
>
>Would you not consider it more useful to let one process have multiple user 
>ids? I do not see why they can have multiple group ids, but only (and 
>exactly) three user ids.

It would raise the complexity enormously. In the kernel, you
currently do if (current->uid == inode->i_uid) or so. If you were to
have multiple identities, that would evolve into a costly "if
(in_user_p(inode->i_uid))" or so, much like in_group_p does it at the
moment.
