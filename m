Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYAFOHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYAFOHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbYAFOH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:07:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:42262 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYAFOH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:07:27 -0500
Date: Sun, 6 Jan 2008 15:07:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Help needed to fix section mismatch warnings
Message-ID: <20080106140728.GA3504@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild emit section mismatch warnings when it detects that someone does a
call from a non-init section to a init section.
The rationale here is that the init section are discarded at runtime and
if this call happens after the init section has gone we have an oops.

This check is planned to be turned into an error soon but we still
see a bit too many warnings.

To see the list below build a kernel like this:

make allyesconfig
Set CONFIG_HOTPLUG to n
(In General Setup | Configure standard kernel features | Support for hot-plugable devices)

Then build the kernel like this:
make KCFLAGS=-fno-unit-at-a-time

The flag "-fno-unit-at-a-time" tell gcc to avoid additional inlining which
otherwise would hide several section mismatch warnings.

With latest kernel I got 113 warnings and most should fixable.
Try to look at how other section mismatch warnings has been fixed for inspiration.

Patches can be cc:ed to me but always send it to the maintainer and lkml.

	Sam

This is the current list of warnings

WARNING: vmlinux.o(.text+0x738a): Section mismatch: reference to .init.data:ebda_addr (between 'discover_ebda' and 'get_model_name')
WARNING: vmlinux.o(.text+0x73c4): Section mismatch: reference to .init.data:ebda_size (between 'discover_ebda' and 'get_model_name')
WARNING: vmlinux.o(.text+0x76e2): Section mismatch: reference to .init.text: (between 'init_amd' and 'detect_ht')
WARNING: vmlinux.o(.text+0x1872b): Section mismatch: reference to .init.text:calibrate_delay (between 'smp_callin' and 'cpu_coregroup_map')
WARNING: vmlinux.o(.text+0x1f8b7): Section mismatch: reference to .init.text: (between 'calgary_handle_quirks' and 'tce_build')
WARNING: vmlinux.o(.text+0x1ffd0): Section mismatch: reference to .init.text:register_cpu (between 'arch_register_cpu' and 'arch_unregister_cpu')
WARNING: vmlinux.o(.text+0x21a39): Section mismatch: reference to .init.text:absent_pages_in_range (between 'reserve_hotadd' and 'unparse_node')
WARNING: vmlinux.o(.text+0x21ae9): Section mismatch: reference to .init.data: (between 'unparse_node' and 'null_slit_node_compare')
WARNING: vmlinux.o(.text+0x38b43): Section mismatch: reference to .init.text:idle_regs (between 'fork_idle' and 'fork_traceflag')
WARNING: vmlinux.o(.text+0x43524): Section mismatch: reference to .init.text: (between 'timer_cpu_notify' and 'msleep')
WARNING: vmlinux.o(.text+0x4c6f6): Section mismatch: reference to .init.text: (between 'rcu_cpu_notify' and 'wakeme_after_rcu')
WARNING: vmlinux.o(.text+0x51cbe): Section mismatch: reference to .init.text: (between 'hrtimer_cpu_notify' and 'down_read_trylock')
WARNING: vmlinux.o(.text+0x89520): Section mismatch: reference to .init.text: (between 'process_zones' and 'pageset_cpuup_callback')
WARNING: vmlinux.o(.text+0x453c6f): Section mismatch: reference to .init.text: (between 'pci_add_new_bus' and 'pci_fixup_parent_subordinate_busnr')
WARNING: vmlinux.o(.text+0x4545f6): Section mismatch: reference to .init.text: (between 'pci_scan_single_device' and 'pci_scan_slot')
WARNING: vmlinux.o(.text+0x4546e9): Section mismatch: reference to .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 'pci_create_bus')
WARNING: vmlinux.o(.text+0x460039): Section mismatch: reference to .init.text: (between 'pci_bus_size_bridges' and 'pci_bus_assign_resources')
WARNING: vmlinux.o(.text+0x46011b): Section mismatch: reference to .init.text: (between 'pci_bus_assign_resources' and 'acpi_query_osc')
WARNING: vmlinux.o(.text+0x47e419): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47e42b): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47e45d): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47e464): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47e488): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47e48f): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47e5a0): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x47e5a7): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x4d2888): Section mismatch: reference to .init.data:mode_option (between 'tdfxfb_setup' and 'getclkMHz')
WARNING: vmlinux.o(.text+0x4d2895): Section mismatch: reference to .init.data: (between 'tdfxfb_setup' and 'getclkMHz')
WARNING: vmlinux.o(.text+0x4e279c): Section mismatch: reference to .init.data: (between 'uvesafb_init_mtrr' and 'uvesafb_show_vbe_ver')
WARNING: vmlinux.o(.text+0x4e2b62): Section mismatch: reference to .init.data:mtrr (between 'param_set_scroll' and 'vesa_setpalette')
WARNING: vmlinux.o(.text+0x4e2b88): Section mismatch: reference to .init.data:mtrr (between 'param_set_scroll' and 'vesa_setpalette')
WARNING: vmlinux.o(.text+0x4e2bab): Section mismatch: reference to .init.data:blank (between 'param_set_scroll' and 'vesa_setpalette')
WARNING: vmlinux.o(.text+0x4e2bb1): Section mismatch: reference to .init.data:blank (between 'param_set_scroll' and 'vesa_setpalette')
WARNING: vmlinux.o(.text+0x50e2ca): Section mismatch: reference to .init.text:pci_acpi_scan_root (between 'acpi_pci_root_add' and 'acpi_pci_root_start')
WARNING: vmlinux.o(.text+0x5eb413): Section mismatch: reference to .init.text: (between 'parport_pc_probe_port' and 'parport_pc_unregister_port')
WARNING: vmlinux.o(.text+0x605e14): Section mismatch: reference to .init.text: (between 'cciss_pci_init' and 'cciss_getgeometry')
WARNING: vmlinux.o(.text+0x6a6a97): Section mismatch: reference to .init.text: (between 'sis190_get_mac_addr' and 'sis190_set_speed_auto')
WARNING: vmlinux.o(.text+0x6a6aa4): Section mismatch: reference to .init.text: (between 'sis190_get_mac_addr' and 'sis190_set_speed_auto')
WARNING: vmlinux.o(.text+0x6f9823): Section mismatch: reference to .init.text: (between 'rhine_hw_init' and 'alloc_ring')
WARNING: vmlinux.o(.text+0x7527bb): Section mismatch: reference to .init.text: (between 'mlx4_init_icm' and 'mlx4_free_icms')
WARNING: vmlinux.o(.text+0x752e91): Section mismatch: reference to .init.text: (between 'mlx4_init_hca' and 'mlx4_setup_hca')
WARNING: vmlinux.o(.text+0x753737): Section mismatch: reference to .init.text: (between '__mlx4_init_one' and 'mlx4_remove_one')
WARNING: vmlinux.o(.text+0x7549da): Section mismatch: reference to .init.text: (between 'mlx4_init_mr_table' and 'mlx4_cleanup_mr_table')
WARNING: vmlinux.o(.text+0x756616): Section mismatch: reference to .init.text: (between 'olympic_open' and 'olympic_rx')
WARNING: vmlinux.o(.text+0xbc61d2): Section mismatch: reference to .init.text: (between 'piix_init_one' and 'pdc_common_port_start')
WARNING: vmlinux.o(.text+0xbc61e9): Section mismatch: reference to .init.text: (between 'piix_init_one' and 'pdc_common_port_start')
WARNING: vmlinux.o(.text+0xbc620f): Section mismatch: reference to .init.text: (between 'piix_init_one' and 'pdc_common_port_start')
WARNING: vmlinux.o(.text+0xe7fdcd): Section mismatch: reference to .init.text:setup_teles3 (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fdd7): Section mismatch: reference to .init.text:setup_s0box (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fde1): Section mismatch: reference to .init.text:setup_telespci (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fdf2): Section mismatch: reference to .init.text:setup_avm_pcipnp (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fdf9): Section mismatch: reference to .init.text:setup_elsa (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe00): Section mismatch: reference to .init.text:setup_diva (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe07): Section mismatch: reference to .init.text:setup_sedlbauer (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe0e): Section mismatch: reference to .init.text:setup_netjet_s (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe15): Section mismatch: reference to .init.text:setup_hfcpci (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe1c): Section mismatch: reference to .init.text:setup_hfcsx (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe23): Section mismatch: reference to .init.text:setup_niccy (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe2a): Section mismatch: reference to .init.text:setup_bkm_a4t (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe31): Section mismatch: reference to .init.text:setup_sct_quadro (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe38): Section mismatch: reference to .init.text:setup_gazel (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe3f): Section mismatch: reference to .init.text:setup_w6692 (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe46): Section mismatch: reference to .init.text:setup_netjet_u (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe7fe4d): Section mismatch: reference to .init.text:setup_enternow_pci (between 'hisax_cs_setup_card' and 'hisax_cs_new')
WARNING: vmlinux.o(.text+0xe98f63): Section mismatch: reference to .init.data:ISACVer (between 'ISACVersion' and 'ph_command')
WARNING: vmlinux.o(.text+0xe9afbc): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'inithscxisac' and 'write_fifo_isac')
WARNING: vmlinux.o(.text+0xe9afcc): Section mismatch: reference to .init.text:initisac (between 'inithscxisac' and 'write_fifo_isac')
WARNING: vmlinux.o(.text+0xe9ec44): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'AVM_card_msg' and 'setup_avm_a1_pcmcia')
WARNING: vmlinux.o(.text+0xe9ed94): Section mismatch: reference to .init.text:setup_isac (between 'setup_avm_a1_pcmcia' and 'WriteHSCX')
WARNING: vmlinux.o(.text+0xea033e): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'AVM_card_msg' and 'hdlc_fill_fifo')
WARNING: vmlinux.o(.text+0xea0346): Section mismatch: reference to .init.text:initisac (between 'AVM_card_msg' and 'hdlc_fill_fifo')
WARNING: vmlinux.o(.text+0xea866c): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'Sedl_card_msg' and 'WriteISACfifo')
WARNING: vmlinux.o(.text+0xea8684): Section mismatch: reference to .init.text:initisac (between 'Sedl_card_msg' and 'WriteISACfifo')
WARNING: vmlinux.o(.text+0xea868c): Section mismatch: reference to .init.text:initisar (between 'Sedl_card_msg' and 'WriteISACfifo')
WARNING: vmlinux.o(.text+0xeacf79): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'NETjet_S_card_msg' and 'dummywr')
WARNING: vmlinux.o(.text+0xeacf81): Section mismatch: reference to .init.text:initisac (between 'NETjet_S_card_msg' and 'dummywr')
WARNING: vmlinux.o(.text+0xeb4a11): Section mismatch: reference to .init.text: (between 'hfcsx_card_msg' and 'hfcsx_Timer')
WARNING: vmlinux.o(.text+0xeb6b57): Section mismatch: reference to .init.text:clear_pending_isac_ints (between 'BKM_card_msg' and 'JadeVersion')
WARNING: vmlinux.o(.text+0xeb6b67): Section mismatch: reference to .init.text:initisac (between 'BKM_card_msg' and 'JadeVersion')
WARNING: vmlinux.o(.text+0xebbc7d): Section mismatch: reference to .init.text:Amd7930_init (between 'enpci_card_msg' and 'enpci_interrupt')
WARNING: vmlinux.o(.text+0xebbcb2): Section mismatch: reference to .init.text:Amd7930_init (between 'enpci_card_msg' and 'enpci_interrupt')
WARNING: vmlinux.o(.text+0xfe90b6): Section mismatch: reference to .init.data:atiixp_quirks (between 'ac97_probing_bugs' and 'snd_atiixp_codec_detect')
WARNING: vmlinux.o(.text+0x109a166): Section mismatch: reference to .init.text: (between 'snd_hdsp_create_alsa_devices' and 'snd_hdsp_free')
WARNING: vmlinux.o(.text+0x10b9600): Section mismatch: reference to .init.text:snd_usb_caiaq_audio_init (between 'setup_card' and 'create_card')
WARNING: vmlinux.o(.text+0x10b9628): Section mismatch: reference to .init.text:snd_usb_caiaq_midi_init (between 'setup_card' and 'create_card')
WARNING: vmlinux.o(.exit.text+0xc64d): Section mismatch: reference to .init.data:_asc_def_iop_base (between 'advansys_isa_remove' and 'advansys_eisa_remove')
WARNING: vmlinux.o(__ksymtab+0xa7a0): Section mismatch: reference to .init.text:suni_init (between '__ksymtab_suni_init' and '__ksymtab_ide_hwifs')
WARNING: vmlinux.o(.data+0x8500): Section mismatch: reference to .init.text:profile_cpu_callback (between 'profile_cpu_callback_nb.22048' and 'lowest_to_date.35229')
WARNING: vmlinux.o(.data+0xb760): Section mismatch: reference to .init.text:workqueue_cpu_callback (between 'workqueue_cpu_callback_nb.15466' and 'init_struct_pid')
WARNING: vmlinux.o(.data+0x167d0): Section mismatch: reference to .init.text:cpu_callback (between 'cpu_callback_nb.29884' and 'sysctl_min_unmapped_ratio')
WARNING: vmlinux.o(.data+0x7e9b8): Section mismatch: reference to .init.text:tpm_inf_pnp_probe (between 'tpm_inf_pnp' and 'cn_idx')
WARNING: vmlinux.o(.data+0xd44d8): Section mismatch: reference to .init.data:prism2_plx_id_table (between 'prism2_plx_drv_id' and 'dev_info')
WARNING: vmlinux.o(.data+0x149908): Section mismatch: reference to .init.text:av7110_attach (between 'av7110_extension' and 'ir_protocol')
WARNING: vmlinux.o(.data+0x170b20): Section mismatch: reference to .init.data:hpt370 (between 'hpt37x_info.32549' and 'driver')
WARNING: vmlinux.o(.data+0x170b28): Section mismatch: reference to .init.data:hpt370a (between 'hpt37x_info.32549' and 'driver')
WARNING: vmlinux.o(.data+0x170b30): Section mismatch: reference to .init.data:hpt372 (between 'hpt37x_info.32549' and 'driver')
WARNING: vmlinux.o(.data+0x170b38): Section mismatch: reference to .init.data:hpt372n (between 'hpt37x_info.32549' and 'driver')
WARNING: vmlinux.o(.data+0x193288): Section mismatch: reference to .init.text:asd_aic9410_setup (between 'asd_pcidev_data' and 'driver_attr_version')
WARNING: vmlinux.o(.data+0x193298): Section mismatch: reference to .init.text:asd_aic9410_setup (between 'asd_pcidev_data' and 'driver_attr_version')
WARNING: vmlinux.o(.data+0x1932a8): Section mismatch: reference to .init.text:asd_aic9405_setup (between 'asd_pcidev_data' and 'driver_attr_version')
WARNING: vmlinux.o(.data+0x1b3ce0): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')
WARNING: vmlinux.o(.data+0x2fdc40): Section mismatch: reference to .init.data:mts64_ctl_smpte_switch (between 'control.19255' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2fdc48): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_hours (between 'control.19255' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2fdc50): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_minutes (between 'control.19255' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2fdc58): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_seconds (between 'control.19255' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2fdc60): Section mismatch: reference to .init.data:mts64_ctl_smpte_time_frames (between 'control.19255' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x2fdc68): Section mismatch: reference to .init.data:mts64_ctl_smpte_fps (between 'control.19255' and 'snd_mts64_rawmidi_output_ops')
WARNING: vmlinux.o(.data+0x300ae0): Section mismatch: reference to .init.text:snd_ad1889_probe (between 'ad1889_pci' and 'index')
WARNING: vmlinux.o(.text+0xb0c71d): Section mismatch: reference to .exit.text: (between 'qla2xxx_pci_error_detected' and 'qla2xxx_pci_mmio_enabled')
WARNING: vmlinux.o(.text+0xb4ff4b): Section mismatch: reference to .exit.text: (between 'sym2_io_error_detected' and 'sym2_io_slot_dump')
WARNING: vmlinux.o(.init.text+0x47783): Section mismatch: reference to .exit.text:tpm_nsc_remove (between 'init_nsc' and 'init_atmel')
WARNING: vmlinux.o(.init.text+0xa73ed): Section mismatch: reference to .exit.text: (between 'asd_pci_probe' and 'aic94xx_init')

