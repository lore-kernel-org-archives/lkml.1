Return-Path: <linux-kernel-owner+w=401wt.eu-S964789AbZHEQqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbZHEQqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934517AbZHEQqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:46:21 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:40860 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934495AbZHEQqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:46:20 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: fanotify - overall design before I start sending patches
Date: Wed, 5 Aug 2009 17:46:16 +0100
User-Agent: KMail/1.9.10
Cc: Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>
References: <1248466429.3567.82.camel@localhost> <20090805020534.GB1354@ucw.cz>
In-Reply-To: <20090805020534.GB1354@ucw.cz>
MIME-Version: 1.0
Message-Id: <200908051746.17903.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/08/2009 17:46:18,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 05/08/2009 17:46:19,
	Serialize complete at 05/08/2009 17:46:19
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009 03:05:34 Pavel Machek wrote:
> BTW my -@suse.cz address no longer works. pavel@ucw.cz should be ok.
>
> > If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> > must send a response before the 5 second timeout.  If no response is
> > sent before the 5 second timeout the original operation is allowed.  If
> > this happens too many times (10 in a row) the fanotify group is evicted
> > from the kernel and will not get any new events.  Sending a response is
> > done using the setsockopt() call with the socket options set to
> > FANOTIFY_ACCESS_RESPONSE.  The buffer should contain a structure like:
>
> The timeout part of interface is very ugly. Will fanotify users have
> to be realtime/mlocked?

Why do you think it is very ugly?

Just to make sure you haven't missed this - it is not that they have to 
complete the whole operation before the timeout period (since you mention 
realtime/mlock I suspect this is what you think?), but _during_ the operation 
they have to show that they are active by sending something like keep alive 
messages.

Or you are worried about failing to meet even that on a loaded system? There 
has to be something like this otherwise hung userspace client would kill the 
whole system.

Tvrtko
