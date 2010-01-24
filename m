Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838Ab0AXVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0AXVKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 16:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723Ab0AXVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 16:10:40 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:39629 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0AXVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 16:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dvsgQQG52YdVxEqw2/EiIEjR7cw2KX5iBwjlGcEfXLcaVVAFpBMXuoq+6QtkfGJiyI
         WkrrrHqKuWwJCZqrFsIY3pcbd36zoDEnBOZrl/1jGFQ8vwSH8in37EVSF6wW7ODqsdh4
         Jtt231SsgaseRTFX5+G26SBxaMSrPPrhzoHVI=
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind@infradead.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Don Mullis <don.mullis@gmail.com>,
       linux-kernel@vger.kernel.org, airlied@redhat.com
In-Reply-To: <20100124205906.GC29555@one.firstfloor.org>
References: <87fx609i29.fsf@gmail.com>
	 <20100121175914.GA8910@basil.fritz.box> <87vdeu96bo.fsf@gmail.com>
	 <87k4vah12u.fsf@basil.nowhere.org>
	 <20100123082839.GB25842@discord.disaster>
	 <20100123113551.GB29555@one.firstfloor.org>
	 <20100123160537.GG25842@discord.disaster>
	 <20100124205906.GC29555@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Jan 2010 23:10:35 +0200
Message-Id: <1264367435.2401.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11)
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-24 at 21:59 +0100, Andi Kleen wrote:
> > Similarly, adding cond_resched() to list_sort means you can stop
> > worrying about the scheduling latency impact of sorting long lists.
> > I fail to see why you're making such a big deal out of this.....
> 
> It's not easy to add it to a low level library function like list_sort()
> because you would need to ensure that all callers are allowed to sleep.
> 
> Or even if all callers currently allow it future ones might not.
> 
> So it would need a new flag or so if needed, completely changing 
> the interface.

Don made IMO a good proposal for the caller to add cond_reshed() in its
'cmp()' callback, if needed. Shouldn't that work fine?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

