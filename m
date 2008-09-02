Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYIBJXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYIBJXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYIBJX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:23:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:36292 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752340AbYIBJX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:23:28 -0400
Date: Tue, 2 Sep 2008 11:23:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Barkalow <barkalow@iabervon.org>
cc: linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <alpine.LNX.1.00.0809012014280.19665@iabervon.org>
Message-ID: <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Daniel Barkalow wrote:

> > Could you please send a dmidecode output from your system, so that we can 
> > compare it to the one provided by Christopher, as he as the system that 
> > apparently needs the nomux quirk to work correctly? It's indeed possible 
> > that there are various systems out there, and the DMI match has to be made 
> > more strict.
> Attached.

Hmm, so you have

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: LENOVO
        Product Name: 076836U
        Version: 3000 N100
        Serial Number: L3H0536
        UUID: 6747DA31-D471-11DA-901B-000FB0C9A0C9
        Wake-up Type: Power Switch
        SKU Number: Not Specified
        Family: Not Specified

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
        Manufacturer: LENOVO
        Product Name: MPAD-MSAE Customer Reference Boards
        Version: Not Applicable
        Serial Number: 41W1220Z1ZBUA6551DK

and the system on which Christopher reported originally this bug to me was

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: LENOVO
        Product Name: 076804U
        Version: 3000 N100
        Serial Number: L3HX754
        UUID: DA02FA2F-A0AC-11DB-A093-000FB0D2560C
        Wake-up Type: Power Switch
        SKU Number: Intel
        Family: Lenovo

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
        Manufacturer: LENOVO
        Product Name: CAPELL VALLEY(NAPA) CRB
        Version: Not Applicable
        Serial Number: 41W8025Z1ZCZ971N36R                                      


so the product name both of System and Base Board are different, and 
apparently the systems differ. Dmitry, what fields would you propose to be 
put in the DMI matching here? I will do the patch then.

Thanks,

-- 
Jiri Kosina
SUSE Labs
