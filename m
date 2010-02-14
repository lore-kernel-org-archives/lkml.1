Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0BNGUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:20:19 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:35319 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0BNGUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:20:17 -0500
Date: Sun, 14 Feb 2010 07:20:15 +0100
From: Marc Haber <mh+linux-kernel-bugs@zugschlus.de>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [Bug #15042] socket(PF_INET6 hangs when ipv6 not yet
	initialized
Message-ID: <20100214062015.GA16912@torres.zugschlus.de>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera> <q60Z28d_9yH.A.oqH.NZMXLB@chimera> <2375c9f91001270110t2a8d08b8n4578df310a6129@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91001270110t2a8d08b8n4578df310a6129@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for the late reply.

On Wed, Jan 27, 2010 at 05:10:44PM +0800, Américo Wang wrote:
> On Mon, Jan 25, 2010 at 6:23 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15042
> > Subject         : socket(PF_INET6 hangs when ipv6 not yet initialized
> > Submitter       : Marc Haber <mh+linux-kernel@zugschlus.de>
> > Date            : 2010-01-10 14:28 (15 days old)
> > References      : http://marc.info/?l=linux-kernel&m=126313553029280&w=4
> >
> 
> (Adding net-dev into Cc)
> 
> Hi, Marc,
> 
> Sorry, I don't really understand your description of the problem, your mean
> your ssh hangs on socket PF_INET6 for 30 seconds?

No, it hangs on socket PF_INET6 indefinetely (max time I waited was
like ten minutes), ignoring SIGTERM while hanging. This does only
happen if the sshd is started within seconds of the ipv6 module being
loaded (or the Interface being brought up), so I guess that the kernel
needs to be in a state where it already thinks that it has IPv6 but
hasn't completed autoconfiguration yet.

To obtain an strace, I had to use timeout --signal=9 30. The
virtualbox process this happens inside takes all host CPU while the
ssh process hangs.

> Have you enabled CONFIG_DETECT_SOFTLOCKUP for your kernel?

yes, that's enabled.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190

Bitte beachten Sie, daß dem [m.E. grundgesetzwidrigen] Gesetz zur
Vorratsdatenspeicherung zufolge, seit dem 1. Januar 2008 jeglicher
elektronische Kontakt (E-Mail, Telefongespräche, SMS, Internet-
Telefonie, Mobilfunk, Fax) mit mir oder anderen Nutzern verdachts-
unabhängig für den automatisierten geheimen Zugriff durch Strafver-
folgungs- u. Polizeivollzugsbehörden, die Bundesanstalt für Finanz-
dienstleistungsaufsicht, Zollkriminal- und Zollfahndungsämter,die
Zollverwaltung zur Schwarzarbeitsbekämpfung, Notrufabfragestellen,
Verfassungsschutzbehörden, den Militärischen Abschirmdienst, Bundes-
nachrichtendienst sowie 52 Staaten wie beispielsweise Aserbeidschan
oder die USA sechs Monate lang gespeichert wird, einschließlich der
Kommunikation mit Berufsgeheimnisträgern wie Ärzten, Journalisten und
Anwälten. Mehr Infos zur totalen Protokollierung Ihrer Kommunikations-
daten auf www.vorratsdatenspeicherung.de. (leicht verändert übernommen
kopiert von www.lawblog.de)
