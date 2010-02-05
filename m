Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab0BEK4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:56:32 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:54067 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0BEK4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:56:30 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 05:56:30 EST
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=Q9AgiXQAw3ICXfyRFOFpE5kl2rNDWfRANb6g614gFMcmEbv8LfB1V/8odhc7JdAkX6abUpIcIC8hOSV/dcZjlQ5DhxNQfDVYP27X9U1hhhYjQk+lvqWDZ1RgQo0ED7oWAGuHbPMscndEP7n928R4VB9xV4Fonb3TPBqlS3TGU/w=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: linux-kernel@vger.kernel.org
Subject: Inconsistency in ioread functions, const pointer or not
User-Agent: KMail/1.12.4 (Linux/2.6.31.8-0.1-default; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Message-ID: <201002051145.23740.roman.fietze@telemotive.de>
Date: Fri, 5 Feb 2010 11:45:23 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 05.02.2010 11:49:07,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 05.02.2010 11:49:47,
	Serialize complete at 05.02.2010 11:49:47
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry if this subject was discussed before, but I could not find
anything except

  http://lkml.indiana.edu/hypermail/linux/kernel/0702.0/0328.html

The old ioreadx routines have been macros using the appropriate readx
functions or macros, those in turn used some raw read functions, which
finally used a memory pointer like this one:

  static inline u8 __raw_readb(const volatile void __iomem *addr)

The iomap ioreadx functions have signatures like

  extern unsigned int ioread8(void __iomem *)

I can understand the discussion about the volatile qualifier, but how
about the const?

Any pointer to discussions about removing const would be helpful.

If there are none of them, does anybody know the reason for removing
the const?

Additional question would be about the return types and target types
for the pointer, why they are int instead of e.g. u8 or void * instead
of u8 *, but probably this has to be another thread or was discussed
somewhere else.


Roman

-- 
Roman Fietze                Telemotive AG Büro Mühlhausen
Breitwiesen                              73347 Mühlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
