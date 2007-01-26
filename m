Return-Path: <linux-kernel-owner+w=401wt.eu-S1161027AbXAZKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027AbXAZKLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161031AbXAZKLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:11:39 -0500
Received: from mxfep04.bredband.com ([195.54.107.79]:33236 "EHLO
	mxfep04.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161027AbXAZKLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:11:38 -0500
Message-ID: <41241.192.168.101.6.1169806186.squirrel@intranet>
In-Reply-To: <20070126052659.GA23250@sergelap.austin.ibm.com>
References: <20070126052659.GA23250@sergelap.austin.ibm.com>
Date: Fri, 26 Jan 2007 11:09:46 +0100 (CET)
Subject: Re: [PATCH] namespaces: fix exit race by splitting exit
From: "Daniel Hokka Zakrisson" <daniel@hozac.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Cedric Le Goater" <clg@fr.ibm.com>,
       "Daniel Hokka Zakrisson" <daniel@hozac.com>, herbert@13thfloor.at,
       akpm@osdl.org, trond.myklebust@fys.uio.no,
       "Linux Containers" <containers@lists.osdl.org>
User-Agent: SquirrelMail/1.4.8-3.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Ok, could you verify that the following patch at least solves
> the oopsing?
>
> (I can't reproduce the oops with Daniel's test prog)
>
> thanks,
> -serge

Indeed, this patch solves the oopsing, but so did the last one. I think I
finally managed to figure out why too, as release_task would be called
with current referring to the parent process, or whoever is reaping the
process with the last reference to the namespace. Right?

Regardless, I have to say I prefer this patch.

-- 
Daniel Hokka Zakrisson
