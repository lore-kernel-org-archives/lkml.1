Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbXKJWK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbXKJWK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXKJWKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:10:47 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:55812 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754569AbXKJWKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:10:46 -0500
Message-ID: <47362C7C.2050202@crispincowan.com>
Date: Sat, 10 Nov 2007 14:11:08 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey>
In-Reply-To: <20071110220455.GB24195@gallifrey>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dr. David Alan Gilbert wrote:
> * Crispin Cowan (crispin@crispincowan.com) wrote:
> <snip
>>     * Manipulating AppArmor policy requires being both root privileged
>>       and not being confined by AppArmor, thus there is explicitly no
>>       capability for non-privileged users to change AppArmor policy.
>>     
> It's a pity that there is no way to do this; it would be nice to restrict
> web browsers, document editors etc but allow them
> to access the places you commonly store documents etc.
>   
I don't get the problem: if you want your web browser to be able to
access where you commonly store your documents, then give it that
permission. The above rule says that your web browser doesn't get to go
change AppArmor policy on its own.

I have serious doubts about the utility of restricting a text editor.
You nominally want to be able to edit any file on the system, so
confining it would be fairly meaningless.

> Similarly I'd like to be able to split applications so that
> the 'preferences' editing facilities are done by separate
> envrionments so that there is no way that a fault in parsing
> external data could edit the config (e.g. change home page or
> proxy in a browser or default document in an editor).
>   
AppArmor will let you do that; most of the work is in splitting the
application. If you can get e.g. Firefox to use a separate process that
it exec's for editing your preferences, then AppArmor can confine that
helper app with a different policy than Firefox itself, including
granting the helper write permission to the config directory.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

