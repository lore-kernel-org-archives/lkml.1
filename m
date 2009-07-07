Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbZGGQOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbZGGQOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbZGGQOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:14:18 -0400
Received: from mail.marco.de ([217.6.149.82]:45554 "HELO mail.marco.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755467AbZGGQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:14:17 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2009 12:14:16 EDT
Message-ID: <4A53728B.9020703@marco.de>
Date: Tue, 07 Jul 2009 18:06:35 +0200
From: Matthias Pfaller <leo@marco.de>
Organization: marco Systemanalyse und Entwicklung GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug in dmi_get_year (causing apic not getting enabled)
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

dmi_get_year extracts the year with:

	simple_strtoul(s, NULL, 0);

for biosdates in 2008 and 2009 this will return 0 because 8 and 9 are no 
valid octal digits. This will e.g. result in the apic not getting enabled.
Changing this to

	simple_strtoul(s, NULL, 10);

should fix the problem.

regards, Matthias Pfaller
-- 
Matthias Pfaller                          Software Entwicklung
marco Systemanalyse und Entwicklung GmbH  Tel   +49 8131 5161 41
Hans-Böckler-Str. 2, D 85221 Dachau       Fax   +49 8131 5161 66
http://www.marco.de/                      Email leo@marco.de
Geschäftsführer Martin Reuter             HRB 171775 Amtsgericht München
