Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbXKMANq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbXKMANq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbXKMANf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:13:35 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:34424 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755135AbXKMANc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:13:32 -0500
Message-ID: <4738EC2E.3030304@crispincowan.com>
Date: Mon, 12 Nov 2007 16:13:34 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: david@lang.hm
CC: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey> <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey> <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> a question for Crispin,
>   is there a wildcard replacement for username? so that you could
> grant permission to /home/$user/.mozilla...... and grant each user
> access to only their own stuff? I realize that in this particular
> example the underlying DAC will handle it, but I can see other cases
> where people may want to have users more intermixed (say webserver
> files or directories for example)
This is possible, but tricky. There is no internal kernel data structure
for a UID's home dir. That is parsable at policy load time, so we could
enhance the language so that a rule of "~/.plan" expanded into a special
token that corresponded to some table of user home directories at the
time the policy was loaded. But that is racy, as it becomes invalid if
anyone's home dir moves, or any users are added or removed.

Another way to do it is what JJ posted: enhance the rule language so you
can have one rule for files that you own, and a different rule for files
owned by others. The AppArmor community (well, JJ and I :) are debating
the cost/benefit of this: is the added flexibility worth the added
complexity?

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

