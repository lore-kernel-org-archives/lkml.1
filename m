Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXEEUrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXEEUrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbXEEUrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:47:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58736 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306AbXEEUri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:47:38 -0400
Message-ID: <463CED7B.5000803@us.ibm.com>
Date: Sat, 05 May 2007 15:47:55 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Shirish S Pargaonkar <shirishp@us.ibm.com>
CC: smfltc@linux.vnet.ibm.com, hch@infradead.org,
       Jeff Layton <jlayton@redhat.com>, linux-cifs-client@lists.samba.org,
       linux-cifs-client-bounces+shirishp=us.ibm.com@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       samba-technical@lists.samba.org
Subject: Re: [linux-cifs-client] Re: [PATCH] CIFS: make sec=none force an
 anonymous mount
References: <OFEFD715DD.89A7A57F-ON872572D2.003A0BCE-862572D2.003AC6CA@us.ibm.com>
In-Reply-To: <OFEFD715DD.89A7A57F-ON872572D2.003A0BCE-862572D2.003AC6CA@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shirish S Pargaonkar wrote:

>
>
> When a session setup request is sent as an anonymous user (NUL user), 
> should/could there be
> password associated with that?
> Right now, sec=none option, will prompt you for a password.
> And when we add code to retry session setup as anonymous user if the 
> first session setup request
> fails, should that retry request be sent with the password or without 
> password?
>
> When smbfs sends requests as an anonymous user, it does not send a 
> password along with it.
>
> Regards,
>
> Shirish
>
We should allow a password to be specified (presumably it is not common 
for a server to have a password associated with a null user),
but probably not prompt (similar to "guest" - except for the case of 
guest, we start with the username of uid of current process, and
only if it fails with access denied do we try "user=" (or equivalently 
sec=none))
